# Which Crates Will Work Off-the-Shelf with WebAssembly?

It is easiest to list the things that do *not* currently work with WebAssembly;
crates which avoid these things tend to be portable to WebAssembly and usually
*Just Work*. A good rule of thumb is that if a crate supports embedded and
`#![no_std]` usage, it probably also supports WebAssembly.

## Things a Crate Might do that Won't Work with WebAssembly

### C and System Library Dependencies

There are no system libraries in wasm, so any crate that tries to bind to a
system library won't work.

Using C libraries will also probably fail to work, since wasm doesn't have a
stable ABI for cross-language communication, and cross-language linking for wasm
is very finicky. Everyone wants this to work eventually, especially since
`clang` is shipping their `wasm32` target by default now, but the story isn't
quite there yet.

### File I/O

WebAssembly does not have access to a file system, so crates that assume the
existence of a file system &mdash; and don't have wasm-specific workarounds
&mdash; will not work.

### Spawning Threads

There are [plans to add threading to WebAssembly][wasm-threading], but it isn't
shipping yet. Attempts to spawn on a thread on the `wasm32-unknown-unknown`
target will panic, which triggers a wasm trap.

[wasm-threading]: https://rustwasm.github.io/2018/10/24/multithreading-rust-and-wasm.html

## So Which General Purpose Crates Tend to Work Off-the-Shelf with WebAssembly?

### Algorithms and Data Structures

Crates that provide the implementation of a particular
[algorithm](https://crates.io/categories/algorithms) or [data
structure](https://crates.io/categories/data-structures), for example A* graph
search or splay trees, tend to work well with WebAssembly.

### `#![no_std]`

[Crates that do not rely on the standard
library](https://crates.io/categories/no-std) tend to work well with
WebAssembly.

### Parsers

[Parsers](https://crates.io/categories/parser-implementations) &mdash; so long
as they just take input and don't perform their own I/O &mdash; tend to work
well with WebAssembly.

### Text Processing

[Crates that deal with the complexities of human language when expressed in
textual form](https://crates.io/categories/text-processing) tend to work well
with WebAssembly.

### Rust Patterns

[Shared solutions for particular situations specific to programming in
Rust](https://crates.io/categories/rust-patterns) tend to work well with WebAssembly.
