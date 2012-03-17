#Setting up service object in the chef run, but action is set to none, so nothing is actually going to happen

service "voxeo-smanager" do
  action [:enable,:restart]
  supports :status=>true, :restart=>true
end

service "voxeo-as" do 
  action [:enable,:nothing]
  supports :status=>true, :restart=>true
end

service "voxeo-ms" do
  action [:enable,:nothing]
  supports :status=>true, :restart=>true
end