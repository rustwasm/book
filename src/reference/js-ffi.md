# JavaScript Interoperation

## Importing and Exporting JS Functions

### From the Rust Side

When using wasm within a JS host, importing and exporting functions from the
Rust side is straightforward: it works very similarly to C.

WebAssembly modules declare a sequence of imports, each with a *module name*
and an *import name*. The module name for an `extern { ... }` block can be
specified using [`#[link(wasm_import_module)]`][wasm_import_module], currently
it defaults to "env".

Exports have only a single name. In addition to any `extern` functions the
WebAssembly instance's default linear memory is exported as "memory".

[wasm_import_module]: https://github.com/rust-lang/rust/issues/52090

```rust
// import a JS function called `foo` from the module `mod`
#[link(wasm_import_module = "mod")]
extern { fn foo(); }

// export a Rust function called `bar`
#[no_mangle]
pub extern fn bar() { /* ... */ }
```

Because of wasm's limited value types, these functions must operate only on
primitive numeric types.

### From the JS Side

Within JS, a wasm binary turns into an ES6 module. It must be *instantiated*
with linear memory and have a set of JS functions matching the expected
imports.  The details of instantiation are available on [MDN][instantiation].

[instantiation]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly/instantiateStreaming

The resulting ES6 module will contain all of the functions exported from Rust, now
available as JS functions.

[Here][hello world] is a very simple example of the whole setup in action.

[hello world]: https://www.hellorust.com/demos/add/index.html

## Going Beyond Numerics

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

[wasm-bindgen]: https://github.com/rustwasm/wasm-bindgen

## Custom Sections

Custom sections allow embedding named arbitrary data into a wasm module. The
section data is set at compile time and is read directly from the wasm module,
it cannot be modified at runtime.

In Rust, custom sections are static arrays (`[T; size]`) exposed with the
`#[link_section]` attribute:

```rust
#[link_section = "hello"]
pub static SECTION: [u8; 24] = *b"This is a custom section";
```

This adds a custom section named `hello` to the wasm file, the rust variable
name `SECTION` is arbitrary, changing it wouldn't alter the behaviour. The
contents are bytes of text here but could be any arbitrary data.

The custom sections can be read on the JS side using the
[`WebAssembly.Module.customSections`] function, it takes a wasm Module and the
section name as arguments and returns an Array of [`ArrayBuffer`]s. Multiple
sections may be specified using the same name, in which case they will all
appear in this array.

```js
WebAssembly.compileStreaming(fetch("sections.wasm"))
.then(mod => {
  const sections = WebAssembly.Module.customSections(mod, "hello");

  const decoder = new TextDecoder();
  const text = decoder.decode(sections[0]);

  console.log(text); // -> "This is a custom section"
});
```

[`ArrayBuffer`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer
[`WebAssembly.Module.customSections`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly/Module/customSections
