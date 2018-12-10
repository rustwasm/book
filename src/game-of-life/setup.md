# Setup

This section describes how to set up the toolchain for compiling Rust programs
to WebAssembly and integrate them into JavaScript.

## The Rust Toolchain

You will need the standard Rust toolchain, including `rustup`, `rustc`, and
`cargo`.

[Follow these instructions to install the Rust toolchain.][rust-install]

The Rust and WebAssembly experience is riding the Rust release trains to stable!
That means we don't require any experimental feature flags. However, we do
require Rust 1.30 or newer.

## `wasm-pack`

`wasm-pack` is your one-stop shop for building, testing, and publishing
Rust-generated WebAssembly.

[Get `wasm-pack` here!][wasm-pack-install]

## `cargo-generate`

[`cargo-generate` helps you get up and running quickly with a new Rust project
by leveraging a pre-existing git repository as a template.][cargo-generate]

Install `cargo-generate` with this command:

```
cargo install cargo-generate
```

## `npm`

`npm` is a package manager for JavaScript. We will use it to install and run a
JavaScript bundler and development server. At the end of the tutorial, we will
publish our compiled `.wasm` to the `npm` registry.

[Follow these instructions to install `npm`.][npm-install]

If you already have `npm` installed, make sure it is up to date with this
command:

```
npm install npm@latest -g
```

[rust-install]: https://www.rust-lang.org/tools/install
[npm-install]: https://www.npmjs.com/get-npm
[wasm-pack]: https://github.com/rustwasm/wasm-pack
[cargo-generate]: https://github.com/ashleygwilliams/cargo-generate
[wasm-pack-install]: https://rustwasm.github.io/wasm-pack/installer/
