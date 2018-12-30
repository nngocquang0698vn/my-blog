# use GitLab Pages' image that bundles a pre-built image for Hugo
FROM registry.gitlab.com/pages/hugo:0.52

WORKDIR /site

CMD ["hugo", "-d", "public", "--enableGitInfo", "--minify"]
