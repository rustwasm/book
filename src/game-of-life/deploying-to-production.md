# Deploying our Game of Life Web Application to Production

When we're happy with the project, the next step is to deploy it to a production
server instead of our local development server. This is generally the same with
Rust and WebAssembly as it is with anything else: put the files somewhere where
they are exposed to the Web via an HTTP server!

We make sure our wasm module is an up-to-date build by running `wasm-pack` from
within the `wasm-game-of-life` directory:

```
wasm-pack build
```

And then we bundle our JavaScript and HTML by running `webpack` within the
`wasm-game-of-life/www` directory:

```
./node_modules/.bin/webpack
```

This bundles the whole Web application—the `.wasm` binary, JavaScript files, and
our HTML—and outputs it into the `wasm-game-of-life/www/dist` directory. Its
contents should looks something like this:

```
wasm-game-of-life/www/dist/
├── 0.bootstrap.js
├── 357c6c6c57e15cecdc07.module.wasm
├── bootstrap.js
└── index.html
```

To use our application from a server, it must be properly configured to serve
`.wasm` files with the correct [MIME type][MIME]—`application/wasm`.

[MIME]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types

> **Note**: Server configuration varies by operating system, it's recommended
> you look up a tutorial for your specific operating system and web server. These
> examples assume an environment like Debian/Ubuntu or CentOS/Red Hat/Fedora.

For example with nginx, [add `application/wasm wasm;` to `/etc/nginx/mime.types`
][nginx-mime]. Then reload nginx with `sudo nginx -s reload` to pick up the
configuration change.

[nginx-mime]: https://nginx.org/en/docs/http/ngx_http_core_module.html#types

For Apache [add `AddType application/wasm .wasm` to the root of your apache
config][apache-mime], likely located at either `/etc/apache2/apache2.conf` or
`/etc/httpd.d/conf/httpd.conf`. Reload Apache with `sudo apachectl -k graceful`.

[apache-mime]: https://httpd.apache.org/docs/2.4/mod/mod_mime.html#addtype

Finally, we can upload the contents of the `dist` directory to the production
server, for example using SCP or an SFTP client. Copying the files to the web
root (usually `/var/www/html` or `/var/www`) will allow anybody to see the final
product.
