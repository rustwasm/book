# Deploying Rust and WebAssembly to Production

> **⚡ Deploying Web applications built with Rust and WebAssembly is nearly
> identical to deploying any other Web application!**

To deploy a Web application that uses Rust-generated WebAssembly on the client,
copy the built Web application's files to your production server's file system
and configure your HTTP server to make them accessible.

## Ensure that Your HTTP Server Uses the `application/wasm` MIME Type

For the fastest page loads, you'll want to use [the
`WebAssembly.instantiateStreaming` function][instantiateStreaming] to pipeline
wasm compilation and instantiation with network transfer (or make sure your
bundler is able to use that function). However, `instantiateStreaming` requires
that the HTTP response has the `application/wasm` [MIME type][] set, or else it
will throw an error.

* [How to configure MIME types for the Apache HTTP server][apache-mime]
* [How to configure MIME types for the NGINX HTTP server][nginx-mime]

[instantiateStreaming]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly/instantiateStreaming
[MIME type]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types
[apache-mime]: https://httpd.apache.org/docs/2.4/mod/mod_mime.html#addtype
[nginx-mime]: https://nginx.org/en/docs/http/ngx_http_core_module.html#types

## Deploying without a Bundler

To deploy to the Web via an ES module, run the command: [`$ wasm-pack build --target web`][target web]. This outputs JS that must be [natively imported as an ES module in a browser alongside the WebAssembly being manually instantiated and loaded][wasm-example].

[wasm-example]: https://wasmbyexample.dev/examples/hello-world/hello-world.rust.en-us.html#implementation
[target web]: https://rustwasm.github.io/wasm-pack/book/commands/build.html#target

## More Resources

* [Best Practices for Webpack in Production.][webpack-prod] Many Rust and
  WebAssembly projects use Webpack to bundle their Rust-generated WebAssembly,
  JavaScript, CSS, and HTML. This guide has tips for getting the most out of
  Webpack when deploying to production environments.
* [Apache documentation.][apache] Apache is a popular HTTP server for use in
  production.
* [NGINX documentation.][nginx] NGINX is a popular HTTP server for use in
  production.

[webpack-prod]: https://webpack.js.org/guides/production/
[apache]: https://httpd.apache.org/docs/
[nginx]: https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/
