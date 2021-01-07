FROM elixir:1.9-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python

RUN mkdir dockerizing_phoenix_umbrella
WORKDIR dockerizing_phoenix_umbrella

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# Install dependencies
RUN mkdir ./apps
RUN mkdir ./apps/dockerizing_phoenix
RUN mkdir ./apps/dockerizing_phoenix_web
# Install JS dependencies
COPY ./apps/dockerizing_phoenix_web/assets/package*.json ./apps/dockerizing_phoenix_web/assets/
RUN npm i --prefix ./apps/dockerizing_phoenix_web/assets
# Install mix dependecies
COPY mix.* ./
COPY ./apps/dockerizing_phoenix/mix.* ./apps/dockerizing_phoenix
COPY ./apps/dockerizing_phoenix_web/mix.* ./apps/dockerizing_phoenix_web
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# Build front-end
COPY ./apps/dockerizing_phoenix_web/assets ./apps/dockerizing_phoenix_web/assets
RUN npm run deploy --prefix ./apps/dockerizing_phoenix_web/assets

# Copy app code
COPY config ./config
COPY apps ./apps

RUN mix phx.digest

# build release
COPY rel ./rel
RUN mix release standard

# prepare release image
FROM alpine:3.9 AS app
# install runtime dependencies
RUN apk add --update openssl postgresql-client

ARG PORT
EXPOSE $PORT
ENV MIX_ENV=prod
# copy release to app container
COPY --from=build /dockerizing_phoenix_umbrella/_build/prod/rel/standard/ .
COPY entrypoint.sh ./entrypoint.sh
CMD ["sh", "./entrypoint.sh"]