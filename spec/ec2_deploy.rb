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
    TestApp.install(aws_settings["access_key_id"],aws_settings["secret_access_key"])
    TestApp.cap('deploy:check')
    $?.success?.should eq true
  end

end