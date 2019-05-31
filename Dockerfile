FROM netyazilim/alpine-base:3.9

ARG VERSION=v1.7.12

RUN wget --quiet --output-document=/bin/traefik https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-amd64 && \
       chmod +x /bin/traefik

FROM scratch

LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"
	   
EXPOSE 80 443 8080 
ENV HOME "/etc"
VOLUME /shared
	   
COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=0 /etc/localtime /etc/localtime
COPY --from=0 /etc/timezone /etc/timezone

COPY --from=0 /bin/traefik /bin/traefik

COPY traefik.toml /etc/.traefik/traefik.toml

ENTRYPOINT ["/bin/traefik"]
