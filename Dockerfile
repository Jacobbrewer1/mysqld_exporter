FROM golang:1.21.1

WORKDIR /app

# Copy the binary from the build
COPY ./bin/app /app/app

RUN ["chmod", "+x", "./app"]

ENTRYPOINT ["/app/app"]
