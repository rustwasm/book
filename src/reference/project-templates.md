# Project Templates

The Rust and WebAssembly working group curates and maintains a variety of
project templates to help you kickstart new projects and hit the ground running.

## `wasm-pack-template`

[This template][wasm-pack-template] is for starting a Rust and WebAssembly
project to be used with [`wasm-pack`][wasm-pack].

Use `cargo generate` to clone this project template:

```
cargo install cargo-generate
cargo generate --git https://github.com/rustwasm/wasm-pack-template.git
```

## `create-wasm-app`

[This template][create-wasm-app] is for JavaScript projects that consume
packages from npm that were created from Rust with [`wasm-pack`][wasm-pack].

Use it with `npm init`:

```
mkdir my-project
cd my-project/
npm init wasm-app
```

This template is often used alongside `wasm-pack-template`, where
`wasm-pack-template` projects are installed locally with `npm link`, and pulled
in as a dependency for a `create-wasm-app` project.

## `rust-webpack-template`

[This template][rust-webpack-template] comes pre-configured with all the
boilerplate for compiling Rust to WebAssembly and hooking that directly into a
Webpack build pipeline with Webpack's [`rust-loader`][rust-loader].

Use it with `npm init`:

```
mkdir my-project
cd my-project/
npm init rust-webpack
```

[wasm-pack]: https://github.com/rustwasm/wasm-pack
[wasm-pack-template]: https://github.com/rustwasm/wasm-pack-template
[create-wasm-app]: https://github.com/rustwasm/create-wasm-app
[rust-webpack-template]: https://github.com/rustwasm/rust-webpack-template
[rust-loader]: https://github.com/wasm-tool/rust-loader/
