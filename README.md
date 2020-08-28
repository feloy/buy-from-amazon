# buy-from-amazon

A container that redirects to the nearest Amazon shop depending on client IP.

## Build

```shell
REGISTRY=<you_docker_registry> IMAGE=<docker_image_name> VERSION=<docker_image_version> ballerina build svc
```

## Configure

Environment varaiables:

- IPSTACK_ACCESS_KEY
- PRODUCT_ID
