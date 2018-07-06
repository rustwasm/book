# "Hello World" for `wasm32-unknown-unknown`

A basic "hello world" can be generated with:

```
$ cargo +nightly new --lib hello-world
```

Normally Rust compiles code for a library in a format meant for other Rust
packages. We want our code to work with wasm though, so we specify that it's a
dynamic library that's C compatible with the following in `Cargo.toml`:

```toml
[lib]
crate-type = ["cdylib"]
```

This sounds a bit weird but the `wasm32` target will know to interpret this
option and instead produce a wasm binary properly. This is meant to get `cargo`
to pass the right parameters to the compiler!

Next, edit `src/lib.rs` to contain:

```rust
#[no_mangle]
pub extern fn add_one(a: u32) -> u32 {
    a + 1
}
```

Now prepare the wasm binary with:

```
$ cargo +nightly build --target wasm32-unknown-unknown --release

# make the binary smaller by removing all unneeded exports, imports, and functions 
# (working around bugs in rustc toolchain)
$ wasm-gc target/wasm32-unknown-unknown/release/hello_world.wasm -o hello_world.gc.wasm
```

And we can test it out with:

```html
<!DOCTYPE html>
<html>
  <head>
    <script>
      WebAssembly.instantiateStreaming(fetch('hello_world.gc.wasm'))
        .then(wasmModule => {
            alert(`2 + 1 = ${wasmModule.instance.exports.add_one(2)}`);
        });
    </script>
  </head>
  <body></body>
</html>
```

Note: To run with `instantiateStreaming` and `compileStreaming`, you need your webserver to serve `.wasm` file with `application/wasm` MIME type. The [https](https://github.com/thecoshman/http) crate can be used to serve files from `localhost`, and includes the `application/wasm` MIME type out of the box.

Alternatively, if you are running locally without any webserver.

```html
<!DOCTYPE html>
<html>
  <head>
    <script>
      fetch('hello_world.gc.wasm')
        .then(r => r.arrayBuffer())
        .then(r => WebAssembly.instantiate(r))
        .then(wasmModule => {
            alert(`2 + 1 = ${wasmModule.instance.exports.add_one(2)}`);
        });
    </script>
  </head>
  <body></body>
</html>
```

If you have Python 3 installed, you can alternatively serve this file with Python's built 
in web server from `localhost`. Python's web server cannot serve `instantiateStreaming` or 
`compileStreaming` due to its lack of support for the `application/wasm` MIME type.

```
$ python3 -m http.server
```

Ensure that your browser supports Wasm. Two options:

- Run this [StackOverflow code snippet](https://stackoverflow.com/a/47880734)

- Search for your browser version's Wasm support on [caniuse.com](https://caniuse.com/#search=wasm)

Open the HTML file with your browser, you should see:

![Wasm Hello World Screenshot](./images/wasm_hello_world_screenshot.png)
