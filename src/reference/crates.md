# Crates You Should Know

This is a curated list of awesome crates you should know about for doing Rust
and WebAssembly development.

[You can also browse all the crates published to crates.io in the WebAssembly
category.][wasm-category]

## Interacting with JavaScript and the DOM

### `wasm-bindgen` | [crates.io](https://crates.io/crates/wasm-bindgen) | [repository](https://github.com/rustwasm/wasm-bindgen)

`wasm-bindgen` facilitates high-level interactions between Rust and
JavaScript. It allows one to import JavaScript things into Rust and export Rust
things to JavaScript.

### `wasm-bindgen-features` | [crates.io](https://crates.io/crates/wasm-bindgen-futures) | [repository](https://github.com/rustwasm/wasm-bindgen/tree/master/crates/futures)

This crate can be used as a connecting bridge between the JavaSript `Promise` and the Rust `Future`.
It can convert in both directions and is useful when working with asynchronous or blocking work in Rust, such as `wasm`,
while it allows to interact with the JavaScript `events` and `I/O Primitives`.

### `js-sys` | [crates.io](https://crates.io/crates/js-sys) | [repository](https://github.com/rustwasm/wasm-bindgen/tree/master/crates/js-sys)

Raw `wasm-bindgen` imports for all the JavaScript global types and methods, such
as `Object`, `Function`, `eval`, etc. These APIs are portable across all
standard ECMAScript environments, not just the Web, such as Node.js.

## Error Reporting

### `console_error_panic_hook` | [crates.io](https://crates.io/crates/console_error_panic_hook) | [repository](https://github.com/rustwasm/console_error_panic_hook)

This crate lets you debug panics on `wasm32-unknown-unknown` by providing a
panic hook that forwards panic messages to `console.error`.

## Dynamic Allocation

### `wee_alloc` | [crates.io](https://crates.io/crates/wee_alloc) | [repository](https://github.com/rustwasm/wee_alloc)

The **W**asm-**E**nabled, **E**lfin Allocator. A small (~1K uncompressed
`.wasm`) allocator implementation for when code size is a greater concern than
allocation performance.

## Parsing and Generating `.wasm` Binaries

### `parity-wasm` | [crates.io](https://crates.io/crates/parity-wasm) | [repository](https://github.com/paritytech/parity-wasm)

Low-level WebAssembly format library for serializing, deserializing, and
building `.wasm` binaries. Good support for well-known custom sections, such as
the "names" section and "reloc.WHATEVER" sections.

### `wasmparser` | [crates.io](https://crates.io/crates/wasmparser) | [repository](https://github.com/yurydelendik/wasmparser.rs)

A simple, event-driven library for parsing WebAssembly binary files. Provides
the byte offsets of each parsed thing, which is necessary when interpreting
relocs, for example.

## Interpreting and Compiling WebAssembly

### `wasmi` | [crates.io](https://crates.io/crates/wasmi) | [repository](https://github.com/paritytech/wasmi)

An embeddable WebAssembly interpreter from Parity.

### `cranelift-wasm` | [crates.io](https://crates.io/crates/cranelift-wasm) | [repository](https://github.com/CraneStation/cranelift)

Compile WebAssembly to the native host's machine code. Part of the Cranelift (né
Cretonne) code generator project.

[wasm-category]: https://crates.io/categories/wasm
