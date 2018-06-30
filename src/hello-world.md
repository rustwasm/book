# "Hello World" for `wasm32-unknown-unknown`

We start out by using [cargo](https://doc.rust-lang.org/cargo/) to generate an empty "hello world" project:

```
$ cargo +nightly new --lib hello-world
```

Next up change `Cargo.toml` to have:

```toml
[lib]
crate-type = ["cdylib"]
```

This is necessary because we're compiling Rust as a dynamic library, to be loaded from JavaScript. We also edit `src/lib.rs` to contain:

```rust
#[no_mangle]
pub extern fn add_one(a: u32) -> u32 {
    a + 1
}
```

Now, we prepare the wasm binary with `wasm-gc`. As previously mentioned, this produces a smaller binary than cargo alone by removing all unneeded exports, imports, and functions.

```

$ wasm-gc target/wasm32-unknown-unknown/release/hello_world.wasm -o hello_world.gc.wasm
```

We can test it out using the following `html` file using `python3`'s builtin `http.server`. Write the following to `index.html`:

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

Then, (assuming you have `python3`) installed, run

```
$ python3 -m http.server
```

Open the HTML file with your browser, you should see:

![Wasm Hello World Screenshot](./images/wasm_hello_world_screenshot.png)

If the example _doesn't_ work, check that your browser supports Wasm. To do so, you can

- Run [this StackOverflow code snippet](https://stackoverflow.com/a/47880734)

- Search for your browser version's Wasm support on [caniuse.com](https://caniuse.com/#search=wasm)
