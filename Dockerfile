FROM heroku/heroku:18-build as build
RUN useradd -m heroku -d /app
USER heroku
COPY --chown=heroku:heroku . /app
WORKDIR /app
RUN mkdir -p /tmp/buildpack/php /tmp/build_cache /tmp/env
RUN curl https://buildpack-registry.s3.amazonaws.com/buildpacks/heroku/php.tgz | tar --warning=none -xz -C /tmp/buildpack/php
RUN STACK=heroku-18 /tmp/buildpack/php/bin/compile /app /tmp/build_cache /tmp/env

FROM heroku/heroku:18
COPY .docker/etc/profile /etc/profile
ENV HOME /app
WORKDIR /app
RUN useradd -m heroku
USER heroku
COPY --from=build /app /app
ENTRYPOINT ["tools/entrypoint.sh"]
