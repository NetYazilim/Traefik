FROM alpine:3.11 AS builder
ARG VERSION=v1.7.21
RUN apk update && apk add --no-cache ca-certificates && update-ca-certificates  && \
    mkdir /traefik && \
    wget --quiet --output-document=/traefik/traefik https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-amd64 && \
    chmod +x /traefik/traefik

FROM scratch
LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"
EXPOSE 80 443 8080 
ENV HOME "/etc"
	   
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /traefik /
COPY traefik.toml /etc/.traefik/traefik.toml
ENTRYPOINT ["/traefik"]
