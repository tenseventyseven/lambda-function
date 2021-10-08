# Trying out node-fetch and axios inside AWS Lambda

Using `node-fetch` version 2:

```shell
npm un node-fetch
npm i node-fetch@2
npm i -D @types/node-fetch@2
```

Using `node-fetch` version 3:

```shell
npm un node-fetch @types/node-fetch
npm i node-fetch
```

To build and run:

```shell
docker build -t lambda-function . && docker run --rm -p 9000:8080 lambda-function
```

To test:

```shell
curl -X POST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"foo": "bar"}'
```

Observations:

1. As per [here](https://github.com/node-fetch/node-fetch#loading-and-configuring-the-module), it seems that `node-fetch` version 3 won't work because we're transpiling to `commonjs`. But is this just because I don't have it set up properly?

2. Why when running the `node-fetch` version 3 build, does the error raised not get caught?
