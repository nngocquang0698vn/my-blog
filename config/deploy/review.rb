server 'jvt.me', user: 'jvt_me', roles: %w{app}
set :deploy_to, "/srv/www/jvt.me/jvt.me/review/#{ENV['CI_COMMIT_REF_SLUG']}"
