# "Hello World" for `wasm32-unknown-unknown`

A basic "hello world" can be generated with:

```
$ cargo +nightly new hello-world
```

Next up change `Cargo.toml` to have:

```toml
[lib]
crate-type = ["cdylib"]
```

and edit `src/lib.rs` to contain:

```rust
#[no_mangle]
pub extern fn add_one(a: u32) -> u32 {
    a + 1
}
```

Now prepare the wasm binary with:

```
$ cargo +nightly build --target wasm32-unknown-unknown --release

# make the binary a little smaller (working around bugs in rustc toolchain)
$ wasm-gc target/wasm32-unknown-unknown/release/hello_world.wasm -o hello_world.gc.wasm

# make the binary *even smaller* if you installed `wasm-opt`
$ wasm-opt -Os hello_world.gc.wasm -o hello_world.gc.opt.wasm
```

And we can test it out with:

```html
<html>
  <head>
    <script type='text/javascript'>
      fetch('hello_world.gc.opt.wasm')
        .then(r => r.arrayBuffer())
        .then(r => WebAssembly.instantiate(r))
        .then(wasm_module => {
            alert(`2 + 1 = ${wasm_module.instance.exports.add_one(2)}`);
        });
    </script>
  </head>
  <body></body>
</html>
```
