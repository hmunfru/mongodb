include_recipe "mongodb::10gen_repo"

package "mongo-10gen" do
  version "2.4.9-mongodb_1"
  options '--nogpgcheck' 
  action :install
end

package "mongo-10gen-server" do
  version "2.4.9-mongodb_1"
  options '--nogpgcheck'
  action :install
end

needs_mongo_gem = (node.recipe?("mongodb::replicaset") or node.recipe?("mongodb::mongos"))

if needs_mongo_gem
  # install the mongo ruby gem at compile time to make it globally available
  gem_package 'mongo' do
    action :nothing
  end.run_action(:install)
  Gem.clear_paths
end

if node.recipe?("mongodb::default") or node.recipe?("mongodb")
  # configure default instance
  mongodb_instance "mongodb" do
    mongodb_type "mongod"
    bind_ip      node['mongodb']['bind_ip']
    port         node['mongodb']['port']
    logpath      node['mongodb']['logpath']
    dbpath       node['mongodb']['dbpath']
    enable_rest  node['mongodb']['enable_rest']
  end
end
