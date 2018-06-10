# Tools

Now that we've have learned how to generate our first WebAssembly "Hello World" with Rust, 
it is time to check out what tooling is available in the language.
There are several great tools already written for WebAssembly (most of them written in C++). 
[Wabt], for instance, is a suite of tools built to be a starting point for manipulating WebAssembly files.

However, since Rust has the potential to be used for both development and tooling for WebAssembly, several tools written in it have popped up in the ecosystem:
- [wasm-gc] - a small command to garbage-collect a Wasm module and remove all unneeded exports, imports, functions, etc.
- [wasm-nm] - list the symbols within a Wasm file.
- [wasm-snip] - replaces a Wasm function body with unreachable
- [parity-wasm] - Wasm (de)serialization in Rust
- [wasmparser] - A Wasm binary decoder with optional validation, in Rust
- [wasmtext] - prints Wasm modules in text format, in Rust
- [wasm-pack] - Package up your Wasm for distribution on npm

Among these tools are a set that aim to allow you to run Wasm outside the browser:
- [rustwasm] - A Wasm interpreter in Rust
- [wasmi] - Another Wasm interpreter in Rust, from Parity
- [wasmstandalone] - standalone JIT-based Wasm runner in Rust, using Cretonne (the same backend [nebulet] uses). In early development.
- [wasm-core] - A Rust library with two execution engines (interpreter and JIT) for Wasm. Used by [cervus] and [IceCore].

There's also plenty of _space for tooling to be be built or rewritten in Rust_ for better synergy with the ecosystem. Some of them include:
- [A Wasm size profiler][wasmsizeprofiler]
- A [Wabt] rewrite in Rust
- Tools for the [ewasm project][ewasm]

This page is meant to be a living document, so feel free to send us a pull request adding new incredible WebAssembly tools we might have missed or when they are released in the future!

[Wabt]: https://github.com/WebAssembly/wabt
[wasm-gc]: https://github.com/alexcrichton/wasm-gc
[wasm-nm]: https://github.com/fitzgen/wasm-nm
[wasm-snip]: https://github.com/fitzgen/wasm-snip
[rustwasm]: https://github.com/joshuawarner32/rust-wasm
[wasmi]: https://github.com/paritytech/wasmi
[parity-wasm]: https://github.com/paritytech/parity-wasm
[wasmparser]: https://github.com/yurydelendik/wasmparser.rs
[wasmtext]: https://github.com/yurydelendik/wasmtext
[wasmstandalone]: https://github.com/sunfishcode/wasmstandalone
[wasmsizeprofiler]: https://github.com/rust-lang-nursery/rust-wasm/issues/20
[ewasm]: https://github.com/ewasm
[wasm-pack]: https://github.com/ashleygwilliams/wasm-pack
[wasm-core]: https://github.com/losfair/wasm-core
[cervus]: https://github.com/cervus-v/cervus
[IceCore]: https://github.com/losfair/IceCore
[nebulet]: https://github.com/nebulet/nebulet
