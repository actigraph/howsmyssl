FROM golang:1.11.4

EXPOSE 10080
EXPOSE 10443

ENV GO111MODULE=on
ADD . /go/src/github.com/actigraph/howsmyssl

RUN cd /go/src/github.com/actigraph/howsmyssl && go install

# Provided by kubernetes secrets or some such
VOLUME "/secrets"

COPY ./config/development*.pem /secrets/
COPY ./config/development*.json /secrets/

RUN chown -R www-data /go/src/github.com/actigraph/howsmyssl

USER www-data

# CMD ["/bin/bash", "-c", "howsmyssl \
#     -httpsAddr=:10443 \
#     -httpAddr=:10080 \
#     -adminAddr=:4567 \
#     -templateDir=/go/src/github.com/actigraph/howsmyssl/templates \
#     -staticDir=/go/src/github.com/actigraph/howsmyssl/static \
#     -vhost=localhost \
#     -acmeRedirect=$ACME_REDIRECT_URL \
#     -allowListsFile=/etc/howsmyssl-allowlists/allow_lists.json \
#     -googAcctConf=/secrets/howsmyssl-logging-svc-account/howsmyssl-logging.json \
#     -allowLogName=howsmyssl_allowance_checks \
#     -cert=/secrets/howsmyssl-tls/tls.crt \
#     -key=/secrets/howsmyssl-tls/tls.key"]

CMD ["/bin/bash", "-c", "howsmyssl \
    -httpsAddr=:10443 \
    -httpAddr=:10080 \
    -vhost=acr-tlsapi-agtlsacr.eastus.azurecontainer.io:10443 \
    -templateDir=/go/src/github.com/actigraph/howsmyssl/templates \
    -staticDir=/go/src/github.com/actigraph/howsmyssl/static \
    -cert=/secrets/development_cert.pem \
    -key=/secrets/development_key.pem"]