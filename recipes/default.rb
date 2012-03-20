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


end

include_recipe "prism::install"
include_recipe "prism::config"
include_recipe "prism::service"
