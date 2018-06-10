# JavaScript Interoperation

### Importing and exporting JS functions

#### From the Rust side

> **Note**: this is likely to [change in the near future][export-issue]

[export-issue]: https://github.com/rustwasm/team/issues/29

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
