# Tools You Should Know

This is a curated list of awesome tools you should know about when doing Rust
and WebAssembly development.

## Development, Build, and Workflow Orchestration

### `wasm-pack` | [repository](https://github.com/rustwasm/wasm-pack)

`wasm-pack` seeks to be a one-stop shop for building and working with Rust-
generated WebAssembly that you would like to interoperate with JavaScript, on
the Web or with Node.js. `wasm-pack` helps you build and publish Rust-generated
WebAssembly to the npm registry to be used alongside any other JavaScript
package in workflows that you already use.

## Optimizing and Manipulating `.wasm` Binaries

### `wasm-opt` | [repository](https://github.com/WebAssembly/binaryen)

The `wasm-opt` tool reads WebAssembly as input, runs transformation,
optimization, and/or instrumentation passes on it, and then emits the
transformed WebAssembly as output. Running it on the `.wasm` binaries produced
by LLVM by way of `rustc` will usually create `.wasm` binaries that are both
smaller and execute faster. This tool is a part of the `binaryen` project.

### `wasm2js` | [repository](https://github.com/WebAssembly/binaryen)

The `wasm2js` tool compiles WebAssembly into "almost asm.js". This is great for
supporting browsers that don't have a WebAssembly implementation, such as
Internet Explorer 11. This tool is a part of the `binaryen` project.

### `wasm-gc` | [repository](https://github.com/alexcrichton/wasm-gc)

A small tool to garbage collect a WebAssembly module and remove all unneeded
exports, imports, functions, etc. This is effectively a `--gc-sections` linker
flag for WebAssembly.

You don't usually need to use this tool yourself because of two reasons:

1. `rustc` now has a new enough version of `lld` that it supports the
   `--gc-sections` flag for WebAssembly. This is automatically enabled for LTO
   builds.
2. The `wasm-bindgen` CLI tool runs `wasm-gc` for you automatically.

### `wasm-snip` | [repository](https://github.com/rustwasm/wasm-snip)

`wasm-snip` replaces a WebAssembly function's body with an `unreachable`
instruction.

Maybe you know that some function will never be called at runtime, but the
compiler can't prove that at compile time? Snip it! Then run `wasm-gc` again and
all the functions it transitively called (which could also never be called at
runtime) will get removed too.

This is useful for forcibly removing Rust's panicking infrastructure in
non-debug production builds.

## Inspecting `.wasm` Binaries

### `twiggy` | [repository](https://github.com/rustwasm/twiggy)

`twiggy` is a code size profiler for `.wasm` binaries. It analyzes a binary's
call graph to answer questions like:

* Why was this function included in the binary in the first place? I.e. which
  exported functions are transitively calling it?
* What is the retained size of this function? I.e. how much space would be saved
  if I removed it and all the functions that become dead code after its removal.

Use `twiggy` to make your binaries slim!

### `wasm-objdump` | [repository](https://github.com/WebAssembly/wabt)

Print low-level details about a `.wasm` binary and each of its sections. Also
supports disassembling into the WAT text format. It's like `objdump` but for
WebAssembly. This is a part of the WABT project.

### `wasm-nm` | [repository](https://github.com/fitzgen/wasm-nm)

List the imported, exported, and private function symbols defined within a
`.wasm` binary. It's like `nm` but for WebAssembly.
