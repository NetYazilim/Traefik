FROM netyazilim/alpine-base:3.8
LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"
ARG VERSION=v1.6.6
RUN wget --quiet --output-document=/bin/traefik https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-amd64 && \
       chmod +x /bin/traefik
VOLUME /shared
ENV TOML "/etc/traefik/traefik.toml" 
COPY bin /bin
COPY etc/traefik /etc/traefik
WORKDIR /bin
EXPOSE 80 443 8080
ENTRYPOINT ["/bin/entrypoint.sh"]
