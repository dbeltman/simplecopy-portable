FROM alpine:3.16.2
RUN apk -q add openssh-client rsync

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

CMD ["/bin/entrypoint.sh"]
