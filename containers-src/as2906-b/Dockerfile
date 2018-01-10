
FROM arbiza/quagga:latest
ADD config /etc/quagga
RUN chown quagga:quagga /etc/quagga/*.conf && chmod 640 /etc/quagga/*.conf
