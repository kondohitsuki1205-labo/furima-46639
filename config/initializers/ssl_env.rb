ENV["SSL_CERT_FILE"] ||= "/etc/ssl/certs/ca-certificates.crt"
ENV["SSL_CERT_DIR"]  ||= "/etc/ssl/certs"
ENV.delete("OPENSSL_CONF")