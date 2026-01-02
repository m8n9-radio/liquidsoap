FROM savonet/liquidsoap:v2.3.3
USER root
RUN apt-get update && apt-get install -y curl jq && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY app/ .
RUN chmod +x /app/entrypoint.sh && \
    chmod 644 /app/*.liq && \
    chown -R liquidsoap:liquidsoap /app
USER liquidsoap
EXPOSE 8001 1234
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/app/main.liq"]
