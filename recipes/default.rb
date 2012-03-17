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

include_recipe "nokogiri"

user node["prism"]["group"] do
  comment "#{node["prism"]["group"]}"
  supports :manage_home => true
end

group node["prism"]["group"] do
  members [node["prism"]["group"]]
end

cookbook_file "/usr/bin/jmxsh" do
  source "jmxsh"
  mode 0744
end

cookbook_file "/usr/bin/jmxsh.jar" do
  source "jmxsh.jar"
  mode 0744
end

cookbook_file "/usr/bin/active_sessions.tcl" do
  source "active_sessions.tcl"
  mode 0644
end

directory "/opt/chef/prism/" do
  recursive true

  owner node["prism"]["user"]
  group node["prism"]["group"]
  mode 0740
end

include_recipe "prism::install"
include_recipe "prism::config"
include_recipe "prism::service"
