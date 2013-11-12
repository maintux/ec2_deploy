require 'aws-sdk'

Capistrano::Configuration.instance.load do

  def ec2_deploy_access_key
    fetch(:ec2_deploy_access_key, nil)
  end
  def ec2_deploy_secret_access
    fetch(:ec2_deploy_secret_access, nil)
  end
  def ec2_deploy_tag_name
    fetch(:ec2_deploy_tag_name, 'role')
  end
  def ec2_deploy_tag_value
    fetch(:ec2_deploy_tag_value, 'web')
  end
  abort("Error! You must define both 'ec2_deploy_access_key' and 'ec2_deploy_secret_access' variables!") if ec2_deploy_access_key.nil? or ec2_deploy_secret_access.nil?

  AWS.config({access_key_id: ec2_deploy_access_key, secret_access_key: ec2_deploy_secret_access, region: 'eu-west-1'})
  ec2 = AWS.ec2
  hosts = []
  ec2.regions.each do |region|
    hosts += region.instances.collect{|i| i.private_ip_address if i.tags.to_h[ec2_deploy_tag_name].eql? ec2_deploy_tag_value}.compact
  end
  abort("No servers found with tag_name #{ec2_deploy_tag_name} and value #{ec2_deploy_tag_value}") if hosts.empty?

  set :ec2_hosts, hosts

end