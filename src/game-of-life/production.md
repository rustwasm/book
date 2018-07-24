# Production & Deployment

When we're happy with the project, the next step is to deploy it to a production
server instead of our development server.

The first step is to run:

```
npm run bundle
```

This creates a release build of our Rust code and uses webpack to bundle it
alongside our JavaScript and HTML, which it outputs into the `dist` directory.

To use our application from a server, it must be properly configured to serve
wasm files with the correct [MIME type][MIME]—`application/wasm`.

[MIME]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types

> **Note**: Server configuration varies by operating system, it's recommended 
you look up a tutorial for your specific operating system and webserver. These
examples assume an environment like Debian/Ubuntu or CentOS/Red Hat/Fedora.

For example with nginx, [add `application/wasm wasm;` to `/etc/nginx/mime.types`
][nginx-mime]. Then reload nginx with `sudo nginx -s reload` to pick up the 
configuration change.

[nginx-mime]: http://nginx.org/en/docs/http/ngx_http_core_module.html#types

For Apache [add `AddType application/wasm .wasm` to the root of your apache
config][apache-mime], likely located at either `/etc/apache2/apache2.conf` or 
`/etc/httpd.d/conf/httpd.conf`. Reload Apache with `sudo apachectl -k graceful`.

[apache-mime]: https://httpd.apache.org/docs/2.4/mod/mod_mime.html#addtype

Finally, we can upload the contents of the `dist` directory to the production 
server, for example using SCP or an SFTP client. Copying the files to the web
root (usually `/var/www/html` or `/var/www`) will allow anybody to see the final
product.
