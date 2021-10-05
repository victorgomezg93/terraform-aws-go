# terraform-aws-go

---
h
Commands:

aws configure
init.bat

We have to introduce the URI in var.tf
log in AWS to install the certificate and copy the arn in alb.tf

terraform init

terraform apply --auto-approve


GUIDE TO CREATE PRIVATE/PUBLIC KEYS
----

First we created the CA

"openssl genrsa -des3 -out rootCA.key 4096"

If you want a non password protected key you can remove the -des3 option but I will use one password

Then I created the self sign root certificate

wsl openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt

I created the certificate key

openssl genrsa -out private.key 2048

And then the sign request to generate the certificate, it's important to provide names in this case to avoid problems with AWS

wsl openssl x509 -req -in mydomain.com.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out public.crt -days 500 -sha256

And then generated the certificate

wsl openssl x509 -req -in mydomain.com.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out public.crt -days 500 -sha256