# Rust + WebAssembly = 💖

This repo aims to be a simple, organic means of coordinating work on using Rust
and WebAssembly together.

Materials about pieces available right now are being collected into a small
[book]; please take a look and contribute!

[book]: https://rust-lang-nursery.github.io/rust-wasm/

<!-- Generated with https://github.com/thlorenz/doctoc -->
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Vision](#vision)
- [Get Involved!](#get-involved)
- [Status](#status)
  - [The Rust compiler](#the-rust-compiler)
  - [The Rust standard library](#the-rust-standard-library)
  - [JS Interop](#js-interop)
    - [The JS package ecosystem](#the-js-package-ecosystem)
    - [The DOM, GC integration, and more](#the-dom-gc-integration-and-more)
  - [The crate ecosystem](#the-crate-ecosystem)
- [Demos, talks and more](#demos-talks-and-more)
- [Rust and WebAssembly book](#rust-and-webassembly-book)
  - [Building the book](#building-the-book)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Vision

**Compiling Rust to WebAssembly should be *the* best choice for fast code for
the Web.**

JavaScript Web applications struggle to reliably hit 60 fps. JavaScript's
dynamic type system and garbage collection pauses don't help. Modern JITs do
what they can, but are still unreliable. Seemingly small code changes can result
in drastic performance regressions if you accidentally wander off the JIT's
happy path.

Rust gives programmers low-level control and reliable performance. It is free
from the non-deterministic GC pauses that JavaScript suffers. And now
WebAssembly lets us bring Rust's advantages to the Web.

Rust is particularly well-suited for the Web. Rust's minuscule runtime enables
small `.wasm` binary sizes and incremental adoption. Binary size is of huge
importance since the `.wasm` must be downloaded over the network. Incrementality
means that existing code bases don't need to be thrown away: programmers can
start by porting their most performance-sensitive JavaScript functions to Rust
to gain immediate benefits. Furthermore, Rust has many of the amenities that Web
developers have come to expect, such as strong package management, expressive
abstractions, and a welcoming community.

Let's make it happen!

*See also [Rust and the case for WebAssembly in 2018.][case-for-wasm]*

We envision the pipeline that fits Rust into JavaScript package management and
bundler ecosystem to look something like this:

<img alt="Rust to WebAssembly to NPM to bundler to Webpage pipeline" src="./pipeline.png"/>

[case-for-wasm]: https://mgattozzi.com/rust-wasm

# Get Involved!

* Join us on IRC at [`#rust-wasm` on `irc.mozilla.org`][irc] ([web chat])

* Read the book, compile some Rust into WebAssembly, and if you ran into a paper
  cut or roadblock, [let us know by filing an issue!][file-issue]

* [Help write the Rust and WebAssembly book](#rust-and-webassembly-book)

* [Fix WebAssembly-specific issues in `rustc`][o-wasm]

* [Write tooling for WebAssembly][tooling]

    * [`wasm-bindgen` is a project for facilitating high-level interactions between wasm modules and JS.][wasm-bindgen]
        * [Design][wasm-bindgen-design]
        * [Open Issues][wasm-bindgen-issues]

    * [`svelte` is a work-in-progress code size profiler for WebAssembly.][svelte]
        * [Contributing][svelte-contributing]
        * [Open Issues][svelte-issues]

* Take a look at [this repo's open issues][issues]

[irc]: irc://irc.mozilla.org#rust-wasm
[web chat]: https://client02.chat.mibbit.com/?channel=%23rust-wasm&server=irc.mozilla.org
[file-issue]: https://github.com/rust-lang-nursery/rust-wasm/issues/new
[o-wasm]: https://github.com/rust-lang/rust/labels/O-wasm
[tooling]: https://github.com/rust-lang-nursery/rust-wasm/issues/10
[issues]: https://github.com/rust-lang-nursery/rust-wasm/issues
[wasm-bindgen]: https://github.com/alexcrichton/wasm-bindgen
[wasm-bindgen-design]: https://github.com/alexcrichton/wasm-bindgen/blob/master/DESIGN.md
[wasm-bindgen-issues]: https://github.com/alexcrichton/wasm-bindgen/issues
[svelte]: https://github.com/fitzgen/svelte
[svelte-contributing]: https://github.com/fitzgen/svelte/blob/master/CONTRIBUTING.md
[svelte-issues]: https://github.com/fitzgen/svelte/issues

# Status

## The Rust compiler

The Rust compiler currently supports two wasm-related targets:

- `wasm32-unknown-unknown`. This target compiles directly to wasm using the LLVM
  back-end. It's appropriate when you're compiling pure Rust code, i.e. you have
  no C dependencies. Compared to the emscripten target, it produces much leaner
  code by default and is much easier to set
  up. [Here's how to set it up](https://rust-lang-nursery.github.io/rust-wasm/setup.html).

- `wasm32-unknown-emscripten`. This target compiles to wasm via the emscripten
  toolchain. It's what you should use if you have C dependencies, including
  libc. [Here's how to set it up](https://www.hellorust.com/setup/emscripten/).

The `wasm32-unknown-unknown` target is particularly promising for integrating bits of
"greenfield" Rust code into JS projects. However, it is also the less mature
backend:

- It [only supports compiling with optimizations on](https://github.com/aturon/rust-wasm/issues/1).
- It [requires compiling with a single, massive compilation unit](https://github.com/aturon/rust-wasm/issues/2).

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

## JS Interop

### The JS package ecosystem

In the book we focused on the details of [function-level interop][book-interop].
But in practice, it's vital to interoperate at the *package* level as well, which
means producing and consuming npm packages.

As of today the story for this sort of interop is largely still in flux, but
there's lots of progress on lots of fronts to cover as well! The crucial
lynchpin of the assumed integration point is **ES6 Modules**. Although [this
requires a polyfill][es6-wasm] the abstraction of ES6 modules for wasm as well
as JS has shown to be beneficial to consumers and bundlers alike.

[book-interop]: https://rust-lang-nursery.github.io/rust-wasm/js-ffi.html
[es6-wasm]: https://github.com/WebAssembly/design/issues/1087

This part of the story is still in the design phase, but here are
some constraints:

- Consumers of Rust/wasm-based packages should be completely unaware that Rust
  is involved. In particular, using such a package should *not* require a local
  Rust toolchain.
  - This means that publication to npm is done in *binary* form: we upload a
    `.wasm` file containing the fully-compiled Rust code.
  - JS is expected to consume Rust through ES6 `import` statements which end up
    resolving to the compiled module.

- You should be able to *work on* the Rust portion of the library using standard
  Cargo workflows.

- There should be a [straightforward way][metadata] to express npm metadata (i.e.
  the contents of `package.json`) for a Rust/wasm project.

  - That means, in particular, that a Rust project might pull in several crates,
    *each* of which pulls in their own npm package dependencies.

- There should be an [easy way][npm-publish] to publish such a project to npm,
  handling all needed [transitive dependencies][rust-deps].

Ultimately, JS bundlers (like [WebPack] and [Parcel]) will need to understand
wasm-based npm packages and generate the appropriate module instantiation. This
is expected to happen through bundlers interpreting wasm modules as ES6 modules
and generating appropriate instantiation glue. Work in this direction is [under
way][bundlers].

[WebPack]: https://webpack.js.org/
[Parcel]: https://parceljs.org/
[bundlers]: https://github.com/aturon/rust-wasm/issues/8
[metadata]: https://github.com/rust-lang-nursery/rust-wasm/issues/34
[rust-deps]: https://github.com/rust-lang-nursery/rust-wasm/issues/36
[npm-publish]: https://github.com/rust-lang-nursery/rust-wasm/issues/35

### The DOM, GC integration, and more

There is some confusion about whether wasm code can work with the DOM today, or
whether that's effectively blocked on GC integration.

To clear this up: **wasm is quite capable of working with the DOM today**. You
can employ strategies like those in [`wasm-bindgen`][wasm-bindgen] to operate on
the DOM via calls back into JS. However, such calls impose an overhead cost.

Efficiency gains are most easily achieved by batching DOM
interactions. Improvements to the DOM, like the [changelist proposal], and
improvements to WebAssembly, like the
[Host Bindings proposal](https://github.com/WebAssembly/design/issues/1148),
will further smooth the path.

[changelist proposal]: https://github.com/whatwg/dom/issues/270

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

# Rust and WebAssembly book

This repo also contains documentation on using Rust for wasm, common workflows,
how to get started and more. It acts as a guide for how to do some neat things
with it. Over time this might extend to more things or act as a more internal
rather than user facing resource as this repo evolves. Considering the early
stage nature of wasm and Rust with wasm the two are indistinguishable right now.

[Open issues for improving the Rust and WebAssembly book.][book-issues]

[book-issues]: https://github.com/rust-lang-nursery/rust-wasm/labels/book

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
