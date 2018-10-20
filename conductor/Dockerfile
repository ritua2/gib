FROM 1.10.4-alpine

# For cases where login in is needed
RUN apk add --no-cache bash && go get github.com/gorilla/mux && go get github.com/go-redis/redis &&\
    go get github.com/influxdata/influxdb/client/v2
