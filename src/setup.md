# Getting Started

If you want to be able to use Rust for wasm then you need an environment to be able to do that! If
you haven't already you'll need to install [rustup][rustup] (the official tool) in order to install
and manage different versions of the Rust compiler. Follow the instructions on the site to get it
installed on your machine. For the time being, you'll need Rust nightly when working with wasm:

```bash
$ rustup default nightly
```

Once that's installed you'll need to get the `wasm32-unknown-unknown` toolchain.

```bash
$ rustup target add wasm32-unknown-unknown --toolchain nightly
```

Next up if you're interested in making small wasm binaries you'll want to
install the [wasm-gc][wasm-gc] tool to make smaller binaries and to work around bugs
in the compiler toolchain for now:

```bash
$ cargo install wasm-gc
```

And finally if you're _really_ interested in making small wasm binaries you'll
want to install `wasm-opt` from the [binaryen toolkit][binaryen].

[rustup]: https://www.rustup.rs/
[binaryen]: https://github.com/WebAssembly/binaryen
[wasm-gc]: https://github.com/alexcrichton/wasm-gc

# Troubleshooting

## I installed `rust` with brew on macOS and can't use wasm-pack

If you get an error like this on macOS:

```text
$ wasm-pack build
[INFO]: 🎯  Checking for the Wasm target...
Error: wasm32-unknown-unknown target not found in sysroot: "/usr/local/Cellar/rust/1.39.0"

Used rustc from the following path: "/usr/local/bin/rustc"
It looks like Rustup is not being used. For non-Rustup setups, the wasm32-unknown-unknown target needs to be installed manually. See https://rustwasm.github.io/wasm-pack/book/prerequisites/non-rustup-setups.html on how to do this.
```

Try running:

```text
brew unlink rust
curl https://sh.rustup.rs -sSf | sh -s
```

To use `rustc` from `rustup`.
