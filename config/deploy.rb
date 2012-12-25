# =============================================================================
# GENERAL SETTINGS
# =============================================================================
set :application, "turfobet"
set :user, "deployer"

set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false
set :deploy_via, :remote_cache
set :scm, :git
set :repository, "git@github.com:sbusso/#{application}.git"
set :git_enable_submodules, 1
set :keep_releases, 3
set :branch, "master"
set :whenever_command, "bundle exec whenever"
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
# ssh_options[:paranoid] = false

after "deploy", "deploy:cleanup" # keep only the last 3 releases

  # =============================================================================
# STAGE SETTINGS
# =============================================================================

# set :default_stage, "experimental"
set :stages, %w(prod vps vm)
set :default_stage, "vm"
require 'capistrano/ext/multistage'

# =============================================================================
# RECIPE INCLUDES
# =============================================================================

# require "whenever/capistrano"
require "bundler/capistrano"
require "capistrano_vps/recipes/base"
require "capistrano_vps/recipes/nginx"
require "capistrano_vps/recipes/unicorn"
require "capistrano_vps/recipes/postgresql_server"
require "capistrano_vps/recipes/postgresql_client"
require "capistrano_vps/recipes/nodejs"
require "capistrano_vps/recipes/redis"
require "capistrano_vps/recipes/rbenv"
require "capistrano_vps/recipes/libxml"
# require "capistrano_vps/recipes/imagemagick"
# require 'sidekiq/capistrano'


after "deploy:update_code", "deploy:whenever"

namespace :deploy do
  desc "Update crontab"
  task :whenever, :roles => :app do
    run "cd #{deploy_to}/current/ && RAILS_ENV=production bundle exec whenever -w #{application}"
  end
end
