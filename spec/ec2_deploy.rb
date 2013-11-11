require 'spec_helper'
include TestApp

describe "EC2 Deploy" do

  it "raise exception if AWS config was not provided" do
    TestApp.install
    TestApp.cap('deploy:check')
    $?.success?.should eq false
  end

  it "Set domain from AWS EC2" do
    aws_settings = YAML.load(File.read(File.expand_path('../config/aws.yml', File.dirname(__FILE__))))
    options = {
      ec2_deploy_access_key: aws_settings["access_key_id"],
      ec2_deploy_secret_access: aws_settings["secret_access_key"],
      ec2_deploy_tag_name: 'role',
      ec2_deploy_tag_value: 'teamartist-org-web'
    }
    TestApp.install(options)
    TestApp.cap('deploy:check')
    $?.success?.should eq true
  end

end