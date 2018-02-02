# WebAssembly Background

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
