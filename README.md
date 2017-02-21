# jvt.me

Jamie Tanna's personal site, built in Jekyll, and enhanced with Gulp.

## Building

The easiest way to build the site is via the Docker container that holds all the dependencies:

```
cd /path/to/repo
docker pull registry.gitlab.com/jamietanna/jvt.me
docker run --net host -v $(readlink -f .):/site -it registry.gitlab.com/jamietanna/jvt.me sh -c 'npm link && bundle install && gulp serve'
```

This will automagically rebuild the site and serve it on `http://localhost:4000`.

Note that you can alternatively build the Docker image from scratch:

```
cd /path/to/repo
docker build -t registry.gitlab.com/jamietanna/jvt.me .
```
