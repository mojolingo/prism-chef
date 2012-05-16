artifact_url = node[:prism][:artifacts][:url]
prism_binary = artifact_url.split("/").last
prism_tmp = Chef::Config[:file_cache_path]
prism_path = node[:prism][:path][:prism]

o = node[:prism][:user]
g = node[:prism][:group]

###############

remote_file "#{prism_tmp}/#{prism_binary}" do
  source artifact_url
  mode 0744
  notifies :run, "script[install_prism]", :immediately

  checksum Artifacts.get_header(artifact_url) || node[:prism][:artifacts][:checksum]
end

script "install_prism" do
  interpreter "bash"
  user "root"
  action :nothing
  cwd prism_tmp
  code <<-EOH
  ./#{prism_binary} -i silent -DUSER_INSTALL_DIR=#{prism_path} -DSTART_SERVICES=0 #{Prism.installer_options(node)}
  /etc/init.d/voxeo-smanager stop
  rm -f #{prism_path}/apps/PrismDemoApp.sar
  EOH
end

cookbook_file "/etc/profile.d/voxeo.sh" do
  source "voxeo.sh"
  mode 0770
  owner o
  group g
end

cookbook_file "#{prism_path}/conf/license.lic" do
  source node[:prism][:license_file]
  mode 0644
  owner o
  group g
  notifies :restart, "service[voxeo-as]"
  notifies :restart, "service[voxeo-ms]"
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

template "/etc/init.d/voxeo-as" do
  source "voxeo-as.erb"
  owner o
  group g
  mode 0770

  notifies :enable, "service[voxeo-as]", :immediately
end

template "/etc/init.d/voxeo-ms" do
  source "voxeo-ms.erb"
  owner o
  group g
  mode 0770

  notifies :enable, "service[voxeo-ms]", :immediately
end

template "/etc/init.d/voxeo-smanager" do
  source "voxeo-smanager.erb"
  mode 0770
  owner o
  group g

  notifies :enable, "service[voxeo-smanager]", :immediately
end

script "chown_files" do
  interpreter "bash"
  user "root"
  code <<-EOH
  chown -R #{o}.#{g} #{prism_path}
  EOH
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

%w(voxeo-as voxeo-ms voxeo-smanager).each do |srv|
  service srv do
    action [:enable]
  end
end

if node[:prism][:enable_webhosting]
  include_recipe "prism::webhosting"
end
