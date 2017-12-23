FROM elixir:1.5.2-alpine

WORKDIR /jose
ADD . /jose

RUN apk add --no-cache git ffmpeg youtube-dl

RUN mix local.hex --force
RUN mix deps.get
RUN mix compile

ENV NAME DeadAss

CMD ["iex", "--sname", "jose", "-S", "mix"]
