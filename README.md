# Tidbyt Apps

Use [pixlet](https://github.com/tidbyt/pixlet) to build apps for [Tidbyt](https://tidbyt.com/) using [Starlark](https://github.com/bazelbuild/starlark).


## Getting started

* Install the [VSCode `vscode-starlark` extension](https://marketplace.visualstudio.com/items?itemName=phgn.vscode-starlark).
* Install the [iOS app](https://tidbyt.com/app).


### Reference

* https://github.com/tidbyt/pixlet/blob/main/docs/
* https://github.com/bazelbuild/starlark


## Development

The `pixlet` executable is included in the project, so you can develop with:

```bash
$ bin/pixlet serve --watch src/example.star
```

Then visit http://localhost:8080/


## Pushing to Tidbyt

Include a `.env` file in the root of the project that includes:

```bash
TIDBYT_DEVICE_ID=the-device-id
TIDBYT_TOKEN=1lkjdf09jasdlfkj23094lslkdfj0.9234nf
```

Those values can be found in the Tidbyt mobile app.

Then to push to the device:

```bash
$ bin/push src/example.star
```
