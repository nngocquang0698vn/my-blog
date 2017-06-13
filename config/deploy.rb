# config valid only for current version of Capistrano
lock '3.7.1'

set :application, 'jvt.me'
set :repo_url, 'git@gitlab.com:jamietanna/jvt.me'

set :branch, ENV['CI_BUILD_REF_NAME'] if ENV['CI_BUILD_REF_NAME']

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/jvt_me/jvt.me'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :registry_url, "registry.gitlab.com"
set :image_path, "jamietanna/jvt.me"
set :tag, ENV['CI_COMMIT_REF_SLUG']
if "master" == fetch(:tag)
  if :production == fetch(:stage) || :staging == fetch(:stage)
    set :tag, "latest"
  end
end
set :image_to_deploy, "#{fetch(:registry_url)}/#{fetch(:image_path)}:#{fetch(:tag)}"

namespace :deploy do
  desc "Deploy the site"

  task :pull do
    desc "Pull the latest image"
    on roles(:app) do
      execute "docker pull #{fetch:image_to_deploy}"
    end
  end

  task :copy do
    desc "Copy the files from the new image to the release_path"
    on roles(:app) do
      within(release_path) do
        container_id = capture("docker run -d #{fetch:image_to_deploy}")
        execute "docker cp #{container_id}:/site/_site #{release_path}"
        execute "docker kill #{container_id}"
      end
    end
  end

  after :updated, :pull
  after :pull, :copy
end
