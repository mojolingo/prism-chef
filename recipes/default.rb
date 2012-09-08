# #
# # Cookbook Name:: prism
# # Recipe:: default
# #
# # Copyright 2011, Voxeo Labs
# #
# # All rights reserved - Do Not Redistribute
# #


class Chef::Recipe
  include Prism
  include Artifacts
end

include_recipe "jmxsh"

artifact_url =  node['prism']['artifacts']['url']
prism_binary =  artifact_url.split("/").last
prism_tmp    =  Chef::Config[:file_cache_path]
prism_path   =  node['prism']['path']['prism']
o            =  node['prism']['user']
g            =  node['prism']['group']

if (node.attribute?('ec2'))
  public_ipv4 = node['ec2']['public_ipv4']
  local_ipv4  = node['ec2']['local_ipv4']
elsif node.attribute?('openstack')
  local_ipv4 = node['ipaddress']
  public_ipv4  = node['openstack']['public_ipv4']
else
  local_ipv4 = node['ipaddress']
  public_ipv4  = Prism.get_public_ipv4
end

###############

remote_file "#{prism_tmp}/#{prism_binary}" do
  source artifact_url
  mode 0744
  notifies :run, "script[install_prism]", :immediately
  checksum Artifacts.get_header(artifact_url)
end

script "install_prism" do
  interpreter "bash"
  user "root"
  action :nothing
  cwd prism_tmp
  code <<-EOH
  ./#{prism_binary} -i silent -DUSER_INSTALL_DIR=#{prism_path} -DSTART_SERVICES=0 #{Prism.installer_options(node)}
  /etc/init.d/voxeo-smanager stop
  EOH
  notifies :delete, "file[#{prism_path}/apps/PrismDemoApp.sar]", :immediately
end

file "#{prism_path}/apps/PrismDemoApp.sar" do
  owner "root"
  group "root"
  mode "0755"
  action :nothing
  only_if do
    node['prism']['delete_prism_demo']
  end
end

# Create Prism user
user o do
  supports :manage_home => true
end

cookbook_file "/etc/profile.d/prism.sh" do
  source "prism.sh"
  mode 0770
  owner o
  group g
end


cookbook_file "#{prism_path}/conf/license.lic" do
  source node['prism']['license_file']
  mode 0644
  owner o
  group g
  notifies :restart, "service[voxeo-as]"
  notifies :restart, "service[voxeo-ms]"
  only_if do
   node['prism']['license_file']
  end
end

%w{var/run/ var/lock/subsys/}.each do |dir|
  directory "#{prism_path}/#{dir}" do
    mode 0775
    owner o
    group g
    action :create
    recursive true
  end
end

%w(voxeo-as voxeo-ms voxeo-smanager).each do |s|
  template "/etc/init.d/#{s}" do
    source "#{s}.erb"
    owner o
    group g
    mode 0770
    variables({
      :prism_path  =>  prism_path,
      :pid_file    =>  node['prism']['pid'],
      :lock_file   =>  node['prism']['lock'],
      :prism_user  =>  node['prism']['user']
    })
    #notifies :enable, "service[voxeo-as]", :immediately
  end

  service s do
    action [:enable]
  end
end

cookbook_file "#{prism_path}/jre/jre/lib/security/cacerts" do
  source "cacerts"
  owner o
  group g
  mode 0644
  notifies :restart, "service[voxeo-as]"
  only_if { FileTest.exist?("#{prism_path}/jre/jre/lib/security/cacerts")}
end

cookbook_file "#{prism_path}/jre/lib/security/cacerts" do
  source "cacerts"
  owner o
  group g
  mode 0644
  notifies :restart, "service[voxeo-as]"
  only_if { FileTest.exist?("#{prism_path}/jre/lib/security/cacerts")}
end

cookbook_file "#{prism_path}/conf/ssl_ca_bundle.crt" do
  source "ssl_ca_bundle.crt"
  owner o
  group g
  mode 0664
  notifies :restart, "service[voxeo-ms]"
end

directory "#{node['prism']['cust_home']}/WEB-INF/" do
  owner o
  group g
  mode 0755
  recursive true
  action :create
  only_if do
    node['prism']['enable_webhosting']
  end
end

template "#{node['prism']['cust_home']}/WEB-INF/web.xml" do
  source "web.xml.erb"
  owner o
  group g
  mode 0744
  variables({
    :dir_listing  =>  node['prism']['hosted_dir_listings']
  })
  only_if do
    node['prism']['enable_webhosting']
  end
end


# Get default interfaces netmask if not specificed via a role attribute
#node['prism']['netmask'] = node[:network][:interfaces][node[:network][:default_interface]][:addresses][node.ipaddress][:netmask]

template "#{prism_path}/conf/sipmethod-users.xml" do
  source "sipmethod-users.xml.erb"
  variables({
  :number_of_test_users =>  node['prism']['sipmethod_users']['number_of_test_users'],
  :admin_username       =>  node['prism']['sipmethod_users']['admin_username'],
  :admin_password       =>  node['prism']['sipmethod_users']['admin_password']
  })
  owner o
  group g
  mode 0664

  only_if  { Prism.mrcp_sessions(node['ipaddress']) == 0 }

  notifies :restart, resources(:service => "voxeo-as")
end

template "#{prism_path}/conf/portappmapping.properties" do
  source "portappmapping.properties.erb"
  owner o
  group g
  mode 0664

  only_if { Prism.mrcp_sessions(node['ipaddress']) == 0 }

  notifies :restart, resources(:service => "voxeo-as")
end

template "#{prism_path}/conf/sipenv.properties" do
  source "sipenv.properties.erb"
  owner o
  group g
  mode 0664
  variables({
    :rmi_username   =>  node['prism']['as']['rmi_username'],
    :rmi_password   =>  node['prism']['as']['rmi_password'],
    :rmi_port       =>  node['prism']['rmi_port']
  })
  notifies :restart, resources(:service => "voxeo-as")
  only_if { Prism.mrcp_sessions(node['ipaddress']) == 0 }
end

template "#{prism_path}/conf/log4j.properties" do
  source "log4j.properties.erb"
  owner o
  group g
  mode 0664
  variables({
    :include_tropo_logger  =>  node['prism']['include_tropo_logger'],
    :max_syslog_msg_size   =>  node['prism']['log4j']['max_syslog_msg_size'],
    :use_tcp               =>  node['prism']['log4j']['syslog']['tcp'],
    :logging_threshold     =>  node['prism']['log4j']['syslog']['threshold'],
    :syslog_servers        =>  node['prism']['syslog_servers'],
    :append_logs           =>  node['prism']['log4j']['append'],
    :max_file_size         =>  node['prism']['log4j']['max_file_size'],
    :max_backup_index      =>  node['prism']['log4j']['max_backup_index'],
    :root_logger           =>  node['prism']['log4j']['root_logger'] + node['prism']['syslog_servers'].count.times.map{|i| "SYSLOG#{i}"}

  })
  notifies :restart, resources(:service => "voxeo-as")
  only_if { Prism.mrcp_sessions(node['ipaddress']) == 0 }
end


template "#{prism_path}/bin/prism" do
  source "prism.erb"
  owner o
  group g
  mode 0774
  variables({
    :prism_path         => node['prism']['path']['prism'],
    :ld_library_extras  => node['prism']['ld_library_extras']
  })
  notifies :restart, resources(:service => "voxeo-as")
  notifies :restart, resources(:service => "voxeo-ms")

  only_if { Prism.mrcp_sessions(node['ipaddress']) == 0 }
end

template "#{prism_path}/conf/vxlaunch.xml" do
  source "vxlaunch.xml.erb"
  owner o
  group g
  mode 0664
  variables({
    :glibc_hack      =>  Prism.requires_glibc_patch(node['kernel']['machine']),
    :prism_home      =>  prism_path,
    :syslog_servers  =>  node['prism']['syslog_servers'],
    :extra_services  =>  node['prism']['VxLaunch']['extra_services']
  })
  notifies :restart, resources(:service => "voxeo-as")
  notifies :restart, resources(:service => "voxeo-ms")

  only_if{ Prism.mrcp_sessions(node['ipaddress']) == 0 }

end

template "#{prism_path}/conf/config.xml" do
  Chef::Log.info("[PRISM] local_ipv4 => #{local_ipv4}")
  Chef::Log.info("[PRISM] public_ipv4 => #{public_ipv4}")
  source "config.xml.erb"
  owner o
  group g
  mode 0664
  variables({
    :prism_path     =>  node['prism']['path']['prism'],
    :local_ipv4     =>  local_ipv4,
    :public_ipv4    =>  public_ipv4,
    :netmask        =>  node['prism']['netmask'],
    :tts_engines    =>  node['prism']['tts_engines'],
    :asr_engines    =>  node['prism']['asr_engines']
  })

  notifies :restart, resources(:service => "voxeo-ms")

  only_if{ Prism.mrcp_sessions(node['ipaddress']) == 0 }
end

template "#{prism_path}/conf/sipmethod.xml" do
  source "sipmethod.xml.erb"
  owner o
  group g
  variables(
  :osgi_enabled              =>  node['prism']['osgi_enabled'],
  :mrcp_ip                   =>  node['prism']['local_ipv4'],
  :bosh_url                  =>  node['prism']['sipmethod']['bosh']['url'],
  :mrcp_port                 =>  node['prism']['mrcp']['port'],
  :address                   =>  node['prism']['local_ipv4'],
  :web_dirs                  =>  [node['prism']['cust_home']],
  :gateway_address           =>  node['prism']['gateway_address'],
  :gateway_transport         =>  node['prism']['gateway_transport'],
  :registration_address      =>  node['prism']['registration_address'],
  :registration_user         =>  node['prism']['registration_user'],
  :registration_address      =>  node['prism']['registration_address'],
  :registration_authuser     =>  node['prism']['registration_authuser'],
  :registration_password     =>  node['prism']['registration_password'],
  :registration_domain       =>  node['prism']['registration_domain'],
  :registration_contact      =>  node['prism']['registration_contact'],
  :registration_expiration   =>  node['prism']['registration_expiration'],
  :relay_address             =>  node['prism']['public_ipv4'],
  :relay_port                =>  node['prism']['relay_port'],
  :xmpp_client_port          =>  node['prism']['xmpp_client_port'],
  :xmpp_server_port          =>  node['prism']['xmpp_server_port'],
  :snmp_enabled              =>  node['prism']['snmp_enabled'],
  :snmp_tcp_listen_address   =>  node['prism']['snmp_tcp_listen_address'],
  :snmp_udp_listen_address   =>  node['prism']['snmp_udp_listen_address'],
  :snmp_udp_port             =>  node['prism']['snmp_udp_port'],
  :snmp_tcp_port             =>  node['prism']['snmp_tcp_port'],
  :snmp_community_name       =>  node['prism']['community_name'],
  :http_port                 =>  node['prism']['http_port'],
  :use_loop_back_address     =>  node['prism']['use_loop_back_address'],
  :udp_network_access_points =>  node['prism']['sipmethod']['NetworkAccessPoint']['udp'],
  :tcp_network_access_points =>  node['prism']['sipmethod']['NetworkAccessPoint']['tcp'],
  :peers                     =>  node['prism']['cluster_peers']
  )
  mode 0664

  notifies :restart, resources(:service => "voxeo-as")
  notifies :restart, resources(:service => "voxeo-ms")

  only_if{ Prism.mrcp_sessions(node['ipaddress']) == 0 }
end

script "chown_files" do
  interpreter "bash"
  user "root"
  code <<-EOH
  chown -R #{o}.#{g} #{prism_path}
  EOH
end

template "#{prism_path}/apps/ROOT/index.jsp" do
  source "index.jsp.erb"
  owner o
  group g
  mode 0644
  variables( :default_home => node['prism']['default_home'] )
end

directory "#{prism_path}/server/apps/console" do
  owner o
  group g
  mode 0755
  action :delete
  recursive true
  only_if do
    node['prism']['delete_console']
  end
end

file "#{prism_path}/server/apps/console.sar" do
  action :delete
  only_if do
    node['prism']['delete_console']
  end
end

%w(voxeo-smanager voxeo-as voxeo-ms).each do |s|
  service s do
    action [:enable,:restart]
    supports :status=>true, :restart=>true
  end
end
