FROM debian
MAINTAINER Jamie Tanna <docker@jamietanna.co.uk>

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm

# Install NodeJS and Ruby {{{
WORKDIR "/opt/node"

ENV NODEJS_VERSION=7.3.0 \
    PATH=$PATH:/opt/node/bin

RUN apt update &&\
	apt upgrade -y &&\
	# NodeJS {{{
	apt install -y curl ca-certificates bzip2 &&\
	curl -sL https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xz --strip-components=1 &&\
	# }}}
	# Ruby {{{
	apt install -y git build-essential ruby-full &&\
  gem install bundle &&\
	# }}}
	# Cleanup {{{
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
	apt-get autoremove -y &&\
	apt-get clean
	# }}}
# }}}

# Install package dependencies {{{
RUN mkdir -p /site/_site
WORKDIR "/site"
ADD package.json /site/
ADD Gemfile /site/
ADD Gemfile.lock /site/

# Install Ruby and NPM depdendencies, globally {{{
# This is so we don't have to work out a nice way of mounting site dependencies
# as well as our site itself
RUN npm install -g
RUN bundle install --system
# }}}

# Ensure that with the new files, we have the right dependencies etc locally {{{
ADD . /site
RUN npm link
ENV PATH=$PATH:/site/node_modules/.bin
RUN bundle install
# }}}

# Build our site {{{
# Finally, we need to build the site, so we've got the latest version of the
# site as part of our image; this means that when deploying, we'll only need to
# mount the _site folder
# }}}
RUN gulp
# }}}
