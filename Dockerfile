FROM nginx:latest

WORKDIR /tmp

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash curl nano git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

EXPOSE 80

CMD bash -c "sleep 360000000 & nginx -g 'daemon off;'"
