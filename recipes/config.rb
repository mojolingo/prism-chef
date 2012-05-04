path =  node[:prism][:path][:prism]
o    =  node[:prism][:user]
g    =  node[:prism][:group]

# Get default interfaces netmask if not specificed via a role attribute
#node[:prism][:netmask] = node[:network][:interfaces][node[:network][:default_interface]][:addresses][node.ipaddress][:netmask]

template "#{path}/conf/sipmethod-users.xml" do
  source "sipmethod-users.xml.erb"
  variables({
  :number_of_test_users =>  node[:prism][:sipmethod_users][:number_of_test_users],
  :admin_username       =>  node[:prism][:sipmethod_users][:admin][:username],
  :admin_password       =>  node[:prism][:sipmethod_users][:admin][:password]
  })
  owner o
  group g
  mode 0664

  only_if  { Prism.mrcp_sessions(node[:ipaddress]) == 0 }

  notifies :restart, resources(:service => "voxeo-as")
  notifies :restart, resources(:service => "voxeo-ms")
end

template "#{path}/conf/portappmapping.properties" do
  source "portappmapping.properties.erb"
  owner o
  group g
  mode 0664

  only_if { Prism.mrcp_sessions(node[:ipaddress]) == 0 }

  notifies :restart, resources(:service => "voxeo-as")
end

template "#{path}/conf/sipenv.properties" do
  source "sipenv.properties.erb"
  owner o
  group g
  mode 0664


  notifies :restart, resources(:service => "voxeo-as")

  only_if { Prism.mrcp_sessions(node[:ipaddress]) == 0 }
end

template "#{path}/conf/log4j.properties" do
  source "log4j.properties.erb"
  owner o
  group g
  mode 0664

  notifies :restart, resources(:service => "voxeo-as")
  notifies :restart, resources(:service => "voxeo-ms")

  only_if { Prism.mrcp_sessions(node[:ipaddress]) == 0 }
end


template "#{path}/bin/prism" do
  source "prism.erb"
  owner o
  group g
  mode 0774

  notifies :restart, resources(:service => "voxeo-as")
  notifies :restart, resources(:service => "voxeo-ms")

  only_if { Prism.mrcp_sessions(node[:ipaddress]) == 0 }
end

template "#{path}/conf/vxlaunch.xml" do
  source "vxlaunch.xml.erb"
  owner o
  group g
  mode 0664
  variables({
    :glibc_hack => Prism.requires_glibc_patch(node[:kernel][:machine])
  })
  notifies :restart, resources(:service => "voxeo-as")
  notifies :restart, resources(:service => "voxeo-ms")

  only_if{ Prism.mrcp_sessions(node[:ipaddress]) == 0 }

end

template "#{path}/conf/config.xml" do
  source "config.xml.erb"
  owner o
  group g
  mode 0664
  variables({
    :local_ipv4     => node[:prism][:local_ipv4],
    :public_ipv4    => node[:prism][:public_ipv4],
    :netmask        => node[:prism][:netmask]
  })

  notifies :restart, resources(:service => "voxeo-ms")

  only_if{ Prism.mrcp_sessions(node[:ipaddress]) == 0 }
end

template "#{path}/conf/sipmethod.xml" do
  Chef::Log.debug "[LABS] ===> local_ipv4  #{node[:prism][:local_ipv4]}"
  Chef::Log.debug "[LABS] ===> relay_port  #{node[:prism][:relay_port]}"
  Chef::Log.debug "[LABS] ===> public_ipv4 #{node[:prism][:public_ipv4]}"

  source "sipmethod.xml.erb"
  owner o
  group g
  variables(
  :osgi_enabled              => node[:prism][:osgi][:enabled],
  :mrcp_ip                   => node[:prism][:local_ipv4], #node["ec2"] ? node["ec2"]["public_ipv4"] : node["prism"]["config"]["MRCPSRV"]["IP"] , # Ticket: 1615349
  :mrcp_port                 => node[:prism][:mrcp][:port],
  :address                   => node[:prism][:local_ipv4],
  :web_dirs                  => [node[:prism][:cust_home]],
  :relay_address             => node[:prism][:public_ipv4],
  :relay_port                => node[:prism][:relay_port],
  :xmpp_client_port          => node[:prism][:xmpp_client_port],
  :xmpp_server_port          => node[:prism][:xmpp_server_port],
  :http_port                 => node[:prism][:http_port],
  :use_loop_back_address     => node[:prism][:use_loop_back_address],
  :udp_network_access_points => node[:prism][:sipmethod][:NetworkAccessPoint][:udp],
  :tcp_network_access_points => node[:prism][:sipmethod][:NetworkAccessPoint][:tcp],
  :peers                     => search(:node, "role:#{node.roles.include?('rayo_gateway') ? 'rayo_gateway' : 'rayo_node'} AND chef_environment:#{node.chef_environment} NOT name:#{node.name}")
  )
  mode 0664

  notifies :restart, resources(:service => "voxeo-as")
  notifies :restart, resources(:service => "voxeo-ms")

  only_if{ Prism.mrcp_sessions(node[:ipaddress]) == 0 }
end
