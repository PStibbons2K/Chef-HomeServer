# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :debug
log_location             STDOUT
cookbook_path            ["#{current_dir}/../cookbooks"]

# check if there is a local file with additional settings specific for the local instance/machine

if ::File.exist?(File.expand_path("../knife.local.rb", __FILE__))
  Chef::Config.from_file(File.expand_path("../knife.local.rb", __FILE__))
end

knife[:editor] = "/usr/bin/vi"

# Example for a local knife configuration file:

#node_name                "chefadmin"
#client_key               "#{current_dir}/chefadmin.pem"
#chef_server_url          "https://chefsrv.example.com/organizations/example"

# Copyright and Author settings
#knife[:cookbook_copyright] = 'Max Mustermann'
#knife[:cookbook_email] = 'none@example.com'
#knife[:cookbook_license] = 'apachev2'
