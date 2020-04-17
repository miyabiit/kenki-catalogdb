# config valid for current version and patch releases of Capistrano
lock "~> 3.13"

set :application, "kenki-catalogdb"
set :repo_url, "git@github.com:miyabiit/kenki-catalogdb.git"
set :deploy_to, "/home/ec2-user/rails_apps/kenki-catalogdb"
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :keep_releases, 3
set :bundle_without,  [:development, :test]
set :user, "ec2-user"
set :group, "ec2-user"

set :rbenv_custom_path, '/usr/local/rbenv'
set :rbenv_type, :user
set :rbenv_ruby, '2.6.5'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails puma pumactl}
set :rbenv_roles, :all # default value

set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, 'v8.16.0'
set :nvm_map_bins, %w{node npm}

set :default_environment, {
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

set :bundle_binstubs, nil
set :linked_files, fetch(:linked_files, []).push('.env')
append :linked_files, "config/puma.rb"
append :linked_files, "config/master.key"
set :linked_dirs, %w{log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle node_modules storage public/.well-known}

set :ssh_options, {
  user: 'ec2-user',
  forward_agent: true
}

set :puma_conf, "#{shared_path}/config/puma.rb"
set :puma_preload_app, false

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/kenki-catalogdb
# set :deploy_to, "/var/www/kenki-catalogdb"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

require 'seed-fu/capistrano3'
before 'deploy:publishing', 'db:seed_fu'

