# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :debug
log_location             STDOUT
cookbook_path            ["#{current_dir}/../cookbooks"]

knife[:editor] = "/usr/bin/vi"


# TODO: Add reference to knife.local.rb - but how?
puts "Hello?"
root_dir = File.dirname(__FILE__)
puts "root dir is " + root_dir
conf = File.join(root_dir, "knife.local.rb")
puts "conf is " + conf
Kernel::load(conf) if File.exists? conf

####
# Example for a local knife configuration file:
####

#node_name                "chefadmin"
#client_key               "#{current_dir}/chefadmin.pem"
#chef_server_url          "https://chefsrv.example.com/organizations/example"

# Copyright and Author settings
#knife[:cookbook_copyright] = 'Max Mustermann'
#knife[:cookbook_email] = 'none@example.com'
#knife[:cookbook_license] = 'apacasdhev2'
