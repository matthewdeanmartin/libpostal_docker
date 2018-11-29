# libpostal_docker
Dockerfile for libpostal

Use this as a base for docker images that need libpostal. Libpostal isn't distributed with pre-compiled binaries. It is compiled on install (which is slow) and then it downloads a lot of data (which is slow and often fails).

You do not want to compile libpostal and download data anymore times that you absolutely have to.

Similar to [libpostal-rest-docker](https://github.com/johnlonganecker/libpostal-rest-docker/blob/master/Dockerfile). That project includes a REST API. This Dockerfile does not.

I created this to support [micro_geocode](https://github.com/matthewdeanmartin/micro_geocode) a more ambitious REST API for a variety of geocoding related libraries.
