FROM alpine:3.10 AS builder
ARG VERSION=v1.7.18
RUN apk update && apk add --no-cache ca-certificates libcap && update-ca-certificates  && \
    mkdir /traefik && \
    wget --quiet --output-document=/traefik/traefik https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-amd64 && \
    chmod +x /traefik/traefik && \
    addgroup -S -g 10101 appuser && \
    adduser -S -D -u 10101 -s /sbin/nologin -h /appuser -G appuser appuser && \
    chown -R appuser:appuser /traefik/traefik 
RUN	setcap 'cap_net_bind_service=+ep' /traefik/traefik

FROM scratch
LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"
EXPOSE 80 443 8080 
ENV HOME "/etc"
	   
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /etc/group /etc/passwd /etc/
COPY --from=builder /traefik /
COPY traefik.toml /etc/.traefik/traefik.toml
USER appuser
ENTRYPOINT ["/traefik"]
