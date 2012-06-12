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
include_recipe "jmxsh"


user node[:prism][:user] do
  comment node[:prism][:user]
  supports :manage_home => true
end

# ruby_block 'reload_prism' do
#   block do
#     node.load_attribute_by_short_filename('default', 'prism')
#   end
#   action :create
# end

include_recipe "prism::install"
include_recipe "prism::config"
include_recipe "prism::service"
