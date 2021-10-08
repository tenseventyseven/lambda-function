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

Log output of container when using `node-fetch@2`:

```log
2021-10-08T00:52:52.446Z        4563db5b-858a-4ea4-a5c9-93a865646cf5    INFO    Caught an error
    at Runtime.handleOnce (/var/runtime/Runtime.js:66:25)3a865646cf5    ERROR   Error: This should be caught?
2021-10-08T00:52:53.236Z        4563db5b-858a-4ea4-a5c9-93a865646cf5    INFO    { userId: 1, id: 1, title: 'delectus aut autem', completed: false }
2021-10-08T00:52:53.751Z        4563db5b-858a-4ea4-a5c9-93a865646cf5    INFO    { userId: 1, id: 1, title: 'delectus aut autem', completed: false }
```

Log output of container when using `node-fetch` (i.e. version 3):

```log
2021-10-08T00:54:49.140Z        undefined       ERROR   Uncaught Exception      {"errorType":"Error","errorMessage":"Must use import to load ES Module: /var/task/node_modules/node-fetch/src/index.js\nrequire() of ES modules is not supported.\nrequire() of /var/task/node_modules/node-fetch/src/index.js from /var/task/index.js is an ES module file as it is a .js file whose nearest parent package.json contains \"type\": \"module\" which defines all .js files in that package scope as ES modules.\nInstead rename /var/task/node_modules/node-fetch/src/index.js to end in .cjs, change the requiring code to use import(), or remove \"type\": \"module\" from /var/task/node_modules/node-fetch/package.json.\n","code":"ERR_REQUIRE_ESM","stack":["Error [ERR_REQUIRE_ESM]: Must use import to load ES Module: /var/task/node_modules/node-fetch/src/index.js","require() of ES modules is not supported.","require() of /var/task/node_modules/node-fetch/src/index.js from /var/task/index.js is an ES module file as it is a .js file whose nearest parent package.json contains \"type\": \"module\" which defines all .js files in that package scope as ES modules.","Instead rename /var/task/node_modules/node-fetch/src/index.js to end in .cjs, change the requiring code to use import(), or remove \"type\": \"module\" from /var/task/node_modules/node-fetch/package.json.","","    at Object.Module._extensions..js (internal/modules/cjs/loader.js:1089:13)","    at Module.load (internal/modules/cjs/loader.js:937:32)","    at Function.Module._load (internal/modules/cjs/loader.js:778:12)","    at Module.require (internal/modules/cjs/loader.js:961:19)","    at require (internal/modules/cjs/helpers.js:92:18)","    at Object.<anonymous> (/var/task/index.js:7:38)","    at Module._compile (internal/modules/cjs/loader.js:1072:14)","    at Object.Module._extensions..js (internal/modules/cjs/loader.js:1101:10)","    at Module.load (internal/modules/cjs/loader.js:937:32)","    at Function.Module._load (internal/modules/cjs/loader.js:778:12)"]}
time="2021-10-08T00:54:49.212" level=warning msg="First fatal error stored in appctx: Runtime.ExitError"
time="2021-10-08T00:54:49.212" level=warning msg="Process 20(bootstrap) exited: Runtime exited with error: exit status 129"
time="2021-10-08T00:54:49.213" level=error msg="Init failed" InvokeID= error="Runtime exited with error: exit status 129"
```

Observations:

1. As per [here](https://github.com/node-fetch/node-fetch#loading-and-configuring-the-module), it seems that `node-fetch` version 3 won't work because we're transpiling to `commonjs`. But is this just because I don't have it set up properly?

2. Why when running the `node-fetch` version 3 build, does the error raised not get caught?
