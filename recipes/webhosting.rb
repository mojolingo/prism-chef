prism_path = node[:prism][:path][:prism]

o = node[:prism][:user]
g = node[:prism][:group]
cust_home = node[:prism][:cust_home]

node.set[:prism][:enable_webhosting] = true


directory "#{cust_home}/WEB-INF/" do
  owner o
  group g
  mode 0755
  recursive true
  action :create
end

template "#{cust_home}/WEB-INF/web.xml" do
  source "web.xml.erb"
  owner o
  group g
  mode 0744
  variables({
    :dir_listing  =>  node[:prism][:hosted_dir_listings]
  })
end
