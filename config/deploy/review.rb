server 'www.review.jvt.me', user: 'www-review-jvt-me', roles: %w{app}
set :deploy_to, "/srv/www/www.review.jvt.me/#{fetch :tag}"
