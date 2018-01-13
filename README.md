# Rust + WebAssembly: an early point of coordination

This repo aims to be a simple, organic means of coordinating early work on using
Rust and WebAssembly together.

# Key WebAssembly background

WebAssembly is a simple machine model and executable format with an [extensive
specification].

[extensive specification]: https://webassembly.github.io/spec/

WebAssembly isn't tied to JS or the web; it makes no assumptions about its host
environment. There is some reason to think that wasm could become an important
"portable executable" format used in a variety of contexts. That said, *today*
wasm is very much about JS, which comes in many flavors (including both browsers
and node.js).

WebAssembly has a minimal set of [value types], essentially limited to simple
numeric values.

[value types]: https://webassembly.github.io/spec/core/syntax/types.html#value-types

WebAssembly has a very simple [memory model]. At the moment, a wasm module has
access to a single "linear memory", which is essentially a flat array of a fixed
numeric type. This [memory can be grown] by a multiple of the page size (64K),
and cannot be shrunk.

[memory model]: https://webassembly.github.io/spec/core/syntax/modules.html#syntax-mem
[memory can be grown]: https://webassembly.github.io/spec/core/syntax/instructions.html#syntax-instr-memory

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

## JS interop

### Importing and exporting JS functions

#### From the Rust side

When using wasm within a JS host, importing and exporting functions from the
Rust side is straightforward: it works exactly like C. In particular:

```rust
// import a JS function called `foo`
extern { fn foo(); }

// export a Rust function called `bar`
#[no_mangle]
pub extern fn bar() { /* ... */ }
```

Because of wasm's limited value types, these functions must operate only on
primitive numeric types.

#### From the JS side

Within JS, a wasm binary turns into an ES6 module. It must be *instantiated*
with a linear memory and set of JS functions matching the expected imports. The
details of instantiation are available on [MDN][instantiation].

[instantiation]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly/instantiate

The resulting ES6 module will contain all of functions exported from Rust, now
available as JS functions.

[Here][hello world] is a very simple example of the whole setup in action.

[hello world]: https://www.hellorust.com/demos/add/index.html

### Going beyond numerics

When using wasm within JS, there is a sharp split between the wasm module's
memory and the JS memory:

- Each wasm module has a linear memory (described at the top of this document),
  which is initialized during instantiation. **JS code can freely read and write
  to this memory**.

- By contrast, wasm code has no *direct* access to JS objects.

Thus, sophisticated interop happens in two main ways:

- Copying in or out binary data to the wasm memory. For example, this is one way
  to provide an owned `String` to the Rust side.

- Setting up an explicit "heap" of JS objects which are then given
  "addresses". This allows wasm code to refer to JS objects indirectly (using
  integers), and operate on those objects by invoking imported JS functions.

Fortunately, this interop story is very amenable to treatment through a generic
"bindgen"-style framework: [wasm-bindgen]. The framework makes it possible to
write idiomatic Rust function signatures that map to idiomatic JS functions,
automatically.

[wasm-bindgen]: https://github.com/alexcrichton/wasm-bindgen

### The JS package ecosystem

So far we've focused on the details of function-level interop. But in practice,
it's vital to interoperate at the *package* level as well, which means producing
and consuming npm packages.

This part of the story is still in the [design phase][npm interop], but here are
some constraints:

- Consumers of Rust/wasm-based packages should be completely unaware that Rust
  is involved. In particular, using such a package should *not* require a local
  Rust toolchain.
  - This means that publication to npm is done in *binary* form: we upload a
    `.wasm` file containing the fully-compiled Rust code.

- You should be able to *work on* the Rust portion of the library using standard
  Cargo workflows.

- There should be a straightforward way to express npm metadata (i.e. the
  contents of `package.json`) for a Rust/wasm project.

  - That means, in particular, that a Rust project might pull in several crates,
    *each* of which pulls in their own npm package dependencies.

- There should be an easy way to publish such a project to npm, handling all
  needed transitive dependencies.

- Ultimately, JS bundlers (like [WebPack] and [Parcel]) will need to understand
  wasm-based npm packages and generate the appropriate module instantiation.

  - Work in this direction is [under way][bundlers].

[WebPack]: https://webpack.js.org/
[Parcel]: https://parceljs.org/
[npm interop]: https://github.com/aturon/rust-wasm/issues/5
[bundlers]: https://github.com/aturon/rust-wasm/issues/8

If you're interested in helping flesh out this story, please jump in on
the [tracking issue][npm interop]!

### The DOM, GC integration, and more

There is some confusion about whether wasm code can work with the DOM today, or
whether that's effectively blocked on GC integration.

To clear this up: **wasm is quite capable of working with the DOM today**. You
can employ strategies like those in [wasm-bindgen] to operate on the DOM via
calls back into JS. However, such calls do impose an overhead, so efficiency
gains are most easily had if once can batch up DOM interactions. Improvements to
the DOM, like the [changelist proposal], will further smooth the path.

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
