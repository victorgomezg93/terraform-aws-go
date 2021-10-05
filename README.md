# Terraform-aws-go

---
DEPLOYMENT
----

This project is build to provide an infraestructure in AWS to deploy a Go server.

In case you want to deploy it you have to do the following:

First in your command line you have to configure the access in aws

```sh
aws configure
```

Then you have an initialization script, it's called "init.bat", this script prompts you and asks for the registryID, when you give this ID the script builds and tag the docker image, create an ECR repository and pushed the imatge into the ECR, also the script checks for terraform configuration files because it's an init script so in case we have an tfstate or lock the script remove this files

```sh
init.bat
```

Once initialized we have to change the registryID in variables.tf and also create the certificate using the certificates located in /app.

Then we can go to the infraestructure folder and use:

```sh
terraform init
terraform apply --auto-approve
```

INFRAESTRUCTURE EXPLANATION
----


GUIDE TO CREATE PRIVATE/PUBLIC KEYS
----

First we created the CA

```sh
openssl genrsa -des3 -out rootCA.key 4096
```

If you want a non password protected key you can remove the -des3 option but I will use one password

Then I created the self sign root certificate

```sh
wsl openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt
```

I created the certificate key

```sh
openssl genrsa -out private.key 2048
```

And then the sign request to generate the certificate, it's important to provide names in this case to avoid problems with AWS

```sh
wsl openssl x509 -req -in mydomain.com.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out public.crt -days 500 -sha256
```

And then generated the certificate

```sh
wsl openssl x509 -req -in mydomain.com.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out public.crt -days 500 -sha256
```