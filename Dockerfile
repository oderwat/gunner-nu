FROM alpine

RUN apk add --no-cache \
    ca-certificates \
    curl \
    git \
    gleam \
    erlang \
    nushell \
    rebar3

WORKDIR /app
RUN gleam new runner
WORKDIR /app/runner
# this will compole the project and cache the dependencies
# the nice side effect is that we do not get all the deprecation warings again
RUN gleam build

CMD ["gleam","run","--no-print-progress"]
