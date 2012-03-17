include_recipe "prism::default"

# Plan to configure SIPPoint here 

# script "install_sipoint" do
#   interpreter "bash"
#   user "root"
#     code <<-EOH
#       if [ -r #{node["prism"]["path"]["prism"]}/modules/sipoint.par ]; then
#         echo "Warn: SIPoint is already deployed. Please undeploy it first if you want to deploy it again."
#       else
#         chmod a+x #{node["prism"]["path"]["prism"]}/server/apps/console/WEB-INF/bin/*
#         if [ -r #{node["prism"]["path"]["prism"]}/jre/bin/java ]; then
#           export JAVA_HOME=#{node["prism"]["path"]["prism"]}/jre
#           export ANT_HOME=#{node["prism"]["path"]["prism"]}/server/apps/console/WEB-INF
#           #{node["prism"]["path"]["prism"]}/server/apps/console/WEB-INF/bin/ant -f deploy.xml deploy
#         else
#           export ANT_HOME=#{node["prism"]["path"]["prism"]}/server/apps/console/WEB-INF
#           #{node["prism"]["path"]["prism"]}/server/apps/console/WEB-INF/bin/ant -f deploy.xml deploy
#         fi
#       fi
#     EOH
# end     