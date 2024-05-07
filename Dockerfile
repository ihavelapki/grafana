# Start with an Alpine base image
FROM alpine:3.16

# Set environment variables
ENV GRAFANA_VERSION 10.0.1

# Update package list and install dependencies
RUN apk add --no-cache \
    bash \
    ca-certificates \
    libc6-compat \
    wget \
    && update-ca-certificates

# Download and install Grafana
RUN wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
    && tar -zxvf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
    && mv grafana-${GRAFANA_VERSION} /usr/share/grafana \
    && ln -s /usr/share/grafana/bin/grafana-server /usr/bin/grafana-server \
    && ln -s /usr/share/grafana/bin/grafana-cli /usr/bin/grafana-cli \
    && rm grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz

# Expose Grafana default port
EXPOSE 3000

# Create Grafana data directory
RUN mkdir -p /var/lib/grafana /etc/grafana /var/log/grafana

# Copy default Grafana configuration
COPY grafana.ini /etc/grafana/grafana.ini

# Define volumes to persist data
VOLUME ["/var/lib/grafana", "/var/log/grafana"]

# Start Grafana server
CMD ["grafana-server", "--config=/etc/grafana/grafana.ini", "cfg:default.paths.data=/var/lib/grafana", "cfg:default.paths.logs=/var/log/grafana"]
