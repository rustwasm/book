# Setup

This section describes how to set up the toolchain for compiling Rust programs
to WebAssembly and integrate them into JavaScript.

## The Rust Toolchain

You will need the standard Rust toolchain, including `rustup`, `rustc`, and
`cargo`.

[Follow these instructions to install the Rust toolchain.][rust-install]

[rust-install]: https://www.rust-lang.org/en-US/install.html

## The `wasm32-unknown-unknown` Target

Once you have the Rust toolchain installed, you'll want to be able to compile
Rust programs to WebAssembly, rather than your machine's native code. You can
enable this by adding the `wasm32-unknown-unknown` target with the following
command:

```
rustup update
rustup install nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
```

## `npm`

`npm` is a package manager for JavaScript. We will use it to install and run a
JavaScript bundler and development server. At the end of the tutorial, we will
publish our compiled `.wasm` to the `npm` registry.

[Follow these instructions to install `npm`.][npm-install]

[npm-install]: https://www.npmjs.com/get-npm

## `wasm-bindgen`

[`wasm-bindgen`][wb] generates bidirectional bindings to and from JavaScript for
Rust and WebAssembly.

Install `wasm-bindgen` with this command:

```
cargo +nightly install wasm-bindgen-cli
```

[wb]: https://github.com/rustwasm/wasm-bindgen
