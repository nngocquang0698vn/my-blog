server 'jvt.me', user: 'jvt_me', roles: %w{app}
set :deploy_to, "/srv/www/jvt.me/jvt.me/review/#{ENV['CI_COMMIT_REF_SLUG']}"

namespace :stop do
  desc 'Stop the Review App'

  task :cleanup do
    execute "rm -rf #{fetch:deploy_to}"
  end
end
