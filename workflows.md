# Common Rust+wasm Workflows

This document is intended to currently collect a number of workflows related to
Rust+wasm over time. Right now it's not necessarily the most organized, but that
may come soon!

## "Hello World" for `wasm32-unknown-unknown`

First up you'll probably want to install the target! That can be done through:

```
$ rustup target add wasm32-unknown-unknown --toolchain nightly
```

Next up if you're interested in making small wasm binaries you'll want to
install the [`wasm-gc`](https://github.com/alexcrichton/wasm-gc) tool to work
around bugs in the compiler toolchain for now:

```
$ cargo install --git https://github.com/alexcrichton/wasm-gc
```

And finally if you're *really* interested in making small wasm binaries you'll
want to install `wasm-opt` from the [binaryen
toolkit](https://github.com/WebAssembly/binaryen).

### Generating a library

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
    <script type='text/javscript'>
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
