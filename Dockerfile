FROM golang:1.14.3-alpine

# Update packages and install dependency packages for services
RUN apk update && apk add --no-cache bash git

# Set GOPATH Environment Variable
ENV GOPATH /go

# Change working directory
WORKDIR $GOPATH/src/gomicroservice/

# Install Go dependencies
RUN go get -u github.com/golang/dep/...
RUN go get -u github.com/derekparker/delve/cmd/dlv/...
COPY . ./
RUN dep ensure -v

# Specified the applcation port
ENV PORT 8080
ENV GIN_MODE release
EXPOSE 8080
# Specified the command to perform
CMD ["go", "run", "server.go"]
