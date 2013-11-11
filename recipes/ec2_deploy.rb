require 'aws-sdk'

Capistrano::Configuration.instance.load do

  def ec2_deploy_access_key
    fetch(:ec2_deploy_access_key, nil)
  end
  def ec2_deploy_secret_access
    fetch(:ec2_deploy_secret_access, nil)
  end

  abort("Error! You must define both 'ec2_deploy_access_key' and 'ec2_deploy_secret_access' variables!") if ec2_deploy_access_key.nil? or ec2_deploy_secret_access.nil?

  AWS.config({access_key_id: ec2_deploy_access_key, secret_access_key: ec2_deploy_secret_access})



end