FROM debian:9

ENV HUGO_VERSION 0.52
ENV HUGO_SHA 0fbc4106f89727e1568772a969a675b73844ea6104df07d1e31b6455bc40ce4c

# Install HUGO
RUN apt update \
  && apt install -y curl git \
  && rm -rf /var/lib/apt/lists/* \
  && curl -SL https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb -o /tmp/hugo.deb \
  && echo "${HUGO_SHA}  /tmp/hugo.deb" | sha256sum -c \
  && dpkg -i /tmp/hugo.deb \
  && hugo version

WORKDIR /site

CMD ["hugo", "-d", "public", "--enableGitInfo", "--minify"]
