FROM alpine:3.20.3

RUN apk -q add openssh-client rsync && \
mkdir -pv /opt/scp
WORKDIR /opt/scp
COPY entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh && pwd && ls -lah

ENTRYPOINT ["./entrypoint.sh"]

