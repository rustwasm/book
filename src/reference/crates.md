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

### `wasm-bindgen-futures` | [crates.io](https://crates.io/crates/wasm-bindgen-futures) | [repository](https://github.com/rustwasm/wasm-bindgen/tree/master/crates/futures)

`wasm-bindgen-futures` is a bridge connecting JavaSript `Promise`s and Rust
`Future`s. It can convert in both directions and is useful when working with
asynchronous tasks in Rust, and allows interacting with DOM events and I/O
operations.

### `js-sys` | [crates.io](https://crates.io/crates/js-sys) | [repository](https://github.com/rustwasm/wasm-bindgen/tree/master/crates/js-sys)

Raw `wasm-bindgen` imports for all the JavaScript global types and methods, such
as `Object`, `Function`, `eval`, etc. These APIs are portable across all
standard ECMAScript environments, not just the Web, such as Node.js.

### `web-sys` | [crates.io](https://crates.io/crates/web-sys) | [repository](https://github.com/rustwasm/wasm-bindgen/tree/master/crates/web-sys)

Raw `wasm-bindgen` imports for all the Web's APIs, such as DOM manipulation,
`setTimeout`, Web GL, Web Audio, etc.

## Error Reporting and Logging

### `console_error_panic_hook` | [crates.io](https://crates.io/crates/console_error_panic_hook) | [repository](https://github.com/rustwasm/console_error_panic_hook)

This crate lets you debug panics on `wasm32-unknown-unknown` by providing a
panic hook that forwards panic messages to `console.error`.

### `console_log` | [crates.io](https://crates.io/crates/console_log) | [repository](https://github.com/iamcodemaker/console_log)

This crate provides a backend for [the `log`
crate](https://crates.io/crates/log) that routes logged messages to the devtools
console.

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
