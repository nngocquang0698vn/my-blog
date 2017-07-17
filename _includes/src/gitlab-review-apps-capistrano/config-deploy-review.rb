server 'review.jvt.me', user: 'review_jvt_me', roles: %w{app}
set :deploy_to, "/srv/www/review.jvt.me/review.jvt.me/review/#{ENV['CI_COMMIT_REF_SLUG']}"
