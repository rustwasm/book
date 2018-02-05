# Rust + WebAssembly: an early point of coordination

This repo aims to be a simple, organic means of coordinating early work on using
Rust and WebAssembly together.

Some of the early material is being collected into a small [book]; please take a 
look and contribute!

[book]: https://rust-lang-nursery.github.io/rust-wasm/

# Status

## The Rust compiler

The Rust compiler currently supports two wasm-related targets:

- `wasm32-unknown-unknown`. This target compiles directly to wasm using the LLVM
  back-end. It's appropriate when you're compiling pure Rust code, i.e. you have
  no C dependencies. Compared to the emscripten target, it produces much leaner
  code by default and is much easier to set
  up. [Here's how to set it up](https://www.hellorust.com/setup/wasm-target/).

- `wasm32-unknown-emscripten`. This target compiles to wasm via the emscripten
  toolchain. It's what you should use if you have C dependencies, including
  libc. [Here's how to set it up](https://www.hellorust.com/setup/emscripten/).

The `wasm32-unknown-unknown` is particularly promising for integrating bits of
"greenfield" Rust code into JS projects. However, it is also the less mature
backend:

- It [only supports compiling with optimizations on](https://github.com/aturon/rust-wasm/issues/1).
- It [requires compiling with a single, massive compilation unit](https://github.com/aturon/rust-wasm/issues/2).
- Some improvements are blocked on [rustc's LLVM lagging far behind](https://github.com/aturon/rust-wasm/issues/3).

## The Rust standard library

Each of the wasm targets has a different story with respect to `std`:

- For `wasm32-unknown-unknown`, Rust emits its own, very small allocator that
  sits on top of the wasm page allocator described above. That means that all
  APIs at the `alloc` level (i.e., all container types) are available. APIs that
  exist only within `std` -- threads, networking, files, processes -- are not
  available for this target. Today, the APIs are present but panic or error out
  upon use. In the future, we plan to `cfg` out the APIs for this target.

  Over time, as the wasm spec grows, some of these additional APIs (notably
  threading) may return.

- For `wasm32-unknown-emscripten`, Rust uses the emscripten toolchain to provide
  libc-based functionality. That means that a lot of `std` is available and
  works, but at the cost of significant binary bloat.

## The crate ecosystem

There's a nascent ecosystem within crates.io for working with wasm. The most
prominent so far are:

- [stdweb], a "standard library for the client-side web".
- [Yew], a framework for client-side web apps.

[stdweb]: https://github.com/koute/stdweb/
[Yew]: https://github.com/DenisKolodin/yew

# Demos, talks and more

- Numerous Rust-centric resources are available at https://www.hellorust.com/,
including demos, talks, and a news feed tracking significant achievements around
Rust and wasm.
- There are also many general wasm resources:
  - http://webassembly.org/
  - https://github.com/mbasso/awesome-wasm
  - http://wasmweekly.news/

# rust-wasm-book

This repo also contains documentation on using Rust for wasm, common workflows,
how to get started and more. It acts as a guide for how to do some neat things
with it. Over time this might extend to more things or act as a more internal
rather than user facing resource as this repo evolves. Considering the early
stage nature of wasm and Rust with wasm the two are indistinguishable right now.

## Building the book

The book is made using [`mdbook`][mdbook]. To install it you'll need `cargo`
installed. If you don't have any Rust tooling installed, you'll need to install
[`rustup`][rustup] first. Follow the instructions on the site in order to get
setup.

Once you have that done then just do the following:

```bash
$ cargo install mdbook
```

Make sure the `cargo install` directory is in your `$PATH` so that you can run
the binary.

Now just run this command from this directory:

```bash
$ mdbook build
```

This will build the book and output files into a directory called `book`. From
there you can navigate to the `index.html` file to view it in your browser. You could
also run the following command to automatically generate changes if you want to
look at changes you might be making to it:

```bash
$ mdbook serve
```

This will automatically generate the files as you make changes and serves them locally so
you can view them easily without having to call `build` every time.

The files are all written in Markdown so if you don't want to generate the book
to read them then you can read them from the `src` directory.

[mdbook]: https://github.com/rust-lang-nursery/mdBook
[rustup]: https://github.com/rust-lang-nursery/rustup.rs/
