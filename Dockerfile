# Alpine and 1.16 in go because is the "newer"
FROM golang:1.16-alpine

# Set the work destination
WORKDIR /app

#copy the files
COPY go.mod .
COPY go.sum .
COPY app/server.go .
COPY app/public.crt .
COPY app/private.key .
RUN go mod download
RUN go mod tidy

# creating the server object
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /server .

#Exposing the port
EXPOSE 8080

CMD [ "/server" ]