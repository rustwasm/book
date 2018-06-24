# Tools

Now that we've have learned how to generate our first WebAssembly "Hello World" with Rust, 
it is time to check out what tooling is available in the language. 
There are several great tools already written for WebAssembly (most of them written in C++). 
[Wabt], for instance, is a suite of tools built to be a starting point for manipulating WebAssembly files.

However, since Rust has the potential to be used for both development and tooling for WebAssembly, several tools written in it have popped up in the ecosystem:
- [wasm-gc] - a small command to gc a wasm module and remove all unneeded exports, imports, functions, etc.
- [wasm-nm] - list the symbols within a wasm file.
- [wasm-snip] - replaces a wasm function body with unreachable
- [parity-wasm] - wasm (de)serialization in Rust
- [wasmparser] - A wasm binary decoder with optional validation, in Rust
- [wasmtext] - prints wasm modules in text format, in Rust
- [wasm-pack] - Package up your wasm for distribution on npm

Among these tools are a set that aim to allow you to run wasm outside the browser:
- [rustwasm] - A wasm interpreter in Rust
- [wasmi] - Another wasm interpreter in Rust, from Parity
- [wasmstandalone] - standalone JIT-based wasm runner in Rust, using Cretonne (the same backend [nebulet] uses). In early development.
- [wasm-core] - A Rust library with two execution engines (interpreter and JIT) for WASM. Used by [cervus] and [IceCore].

There's also plenty of _space for tooling to be built or rewritten in Rust_ for better synergy with the ecosystem. Some of them include:
- [A wasm size profiler][wasmsizeprofiler]
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
[wasmsizeprofiler]: https://github.com/rustwasm/team/issues/20
[ewasm]: https://github.com/ewasm
[wasm-pack]: https://github.com/rustwasm/wasm-pack
[wasm-core]: https://github.com/losfair/wasm-core
[cervus]: https://github.com/cervus-v/cervus
[IceCore]: https://github.com/losfair/IceCore
[nebulet]: https://github.com/nebulet/nebulet
