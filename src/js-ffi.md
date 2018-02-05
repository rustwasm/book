# JavaScript Interoperation

### Importing and exporting JS functions

#### From the Rust side

> **Note**: this is likely to [change in the near future][export-issue]

[export-issue]: https://github.com/rust-lang-nursery/rust-wasm/issues/29

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

As of today the story for this sort of interop is largely still in flux, but
there's lots of progress on lots of fronts to cover as well! The crucial
lynchpin of the assumed integration point is **ES6 Modules**. Although [this
requires a polyfill][es6-wasm] the abstraction of ES6 modules for wasm as well
as JS has shown to be beneficial to consumers and bundlers alike.

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

- There should be a [straightforward way][metdata] to express npm metadata (i.e.
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

If you're interested in helping flesh out this story, please jump in on
the [tracking issue][npm interop]!

### The DOM, GC integration, and more

There is some confusion about whether wasm code can work with the DOM today, or
whether that's effectively blocked on GC integration.

To clear this up: **wasm is quite capable of working with the DOM today**. You
can employ strategies like those in [wasm-bindgen] to operate on the DOM via
calls back into JS. However, such calls do impose an overhead, so efficiency
gains are most easily had if once can batch up DOM interactions. Improvements to
the DOM, like the [changelist proposal], and improvements to WebAssembly, like
the [Host Bindings proposal](https://github.com/WebAssembly/design/issues/1148),
will further smooth the path.

[changelist proposal]: https://github.com/whatwg/dom/issues/270

