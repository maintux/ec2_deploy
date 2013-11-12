require 'spec_helper'
require 'json'
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
      ec2_deploy_tag_name: aws_settings["tag_name"],
      ec2_deploy_tag_value: aws_settings["tag_value"]
    }
    TestApp.install(options)
    hosts = JSON.parse(TestApp.get_ec2_hosts)
    hosts.should =~ aws_settings["test_hosts"]
  end

end