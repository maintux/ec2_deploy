require 'fileutils'
module TestApp
  extend self

  def install(options={})
    custom_config = ""
    if options[:ec2_deploy_access_key] and options[:ec2_deploy_secret_access]
      custom_config = %{
        set :ec2_deploy_access_key, '#{options[:ec2_deploy_access_key]}'
        set :ec2_deploy_secret_access, '#{options[:ec2_deploy_secret_access]}'
        set :ec2_deploy_tag_name, '#{options[:ec2_deploy_tag_name]||'role'}'
        set :ec2_deploy_tag_value, '#{options[:ec2_deploy_tag_value]||'web'}'
      }
    end
    custom_config = custom_config + "require 'ec2_deploy'"
    install_test_app_with(custom_config + default_config)
  end

  def default_config
    %{
      set :application, 'test_app'
      set :repo_url, 'git://github.com/capistrano/capistrano.git'
      set :branch, 'master'
      role :web, *ec2_hosts
    }
  end

  def create_test_app
    FileUtils.rm_rf(test_app_path)
    FileUtils.mkdir(test_app_path)

    File.open(gemfile, 'w+') do |file|
      file.write "gem 'capistrano'\n"
      file.write "gem 'ec2_deploy', path: '#{path_to_ec2_deploy}'"
    end

    Dir.chdir(test_app_path) do
      %x[bundle]
    end
  end

  def install_test_app_with(config)
    create_test_app
    Dir.chdir(test_app_path) do
      %x[bundle exec capify .;mkdir config/deploy]
    end
    write_local_deploy_file(config)
  end

  def write_local_deploy_file(config)
    File.open(test_stage_path, 'w') do |file|
      file.write config
    end
  end

  def prepend_to_capfile(config)
    current_capfile = File.read(capfile)
    File.open(capfile, 'w') do |file|
      file.write config
      file.write current_capfile
    end
  end

  def create_shared_directory(path)
    FileUtils.mkdir_p(shared_path.join(path))
  end

  def create_shared_file(path)
    File.open(shared_path.join(path), 'w')
  end

  def cap(task)
    run "bundle exec cap -n #{task}"
  end

  def run(command)
    Dir.chdir(test_app_path) do
      %x[#{command}]
    end
    $?.success?
  end

  def test_stage_path
    test_app_path.join('config/deploy.rb')
  end

  def test_app_path
    Pathname.new('/tmp/test_app')
  end

  def shared_path
    deploy_to.join('shared')
  end

  def current_path
    deploy_to.join('current')
  end

  def releases_path
    deploy_to.join('releases')
  end

  def release_path
    releases_path.join(timestamp)
  end

  def timestamp
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def repo_path
    deploy_to.join('repo')
  end

  def path_to_ec2_deploy
    File.expand_path('.')
  end

  def gemfile
    test_app_path.join('Gemfile')
  end

  def capfile
    test_app_path.join('Capfile')
  end

  def current_user
    `whoami`.chomp
  end

  def task_dir
    test_app_path.join('lib/capistrano/tasks')
  end

  def copy_task_to_test_app(source)
    FileUtils.cp(source, task_dir)
  end

  def config_path
    test_app_path.join('config')
  end

  def move_configuration_to_custom_location(location)
    prepend_to_capfile(
      %{
        set :stage_config_path, "app/config/deploy"
        set :deploy_config_path, "app/config/deploy.rb"
      }
    )

    location = test_app_path.join(location)
    FileUtils.mkdir_p(location)
    FileUtils.mv(config_path, location)
  end

end