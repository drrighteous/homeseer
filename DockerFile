FROM mono:latest

RUN apt-get update && apt-get install -y \
    flite chromium wget

ADD start.sh /

VOLUME [ "/data" ]

CMD ["sh", "/start.sh"]
