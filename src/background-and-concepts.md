# Background and Concepts

## Web Assembly
WebAssembly is a simple machine model and executable format with an [extensive
specification].

Although it has currently gathered attention in the JavaScript and web communities in general,
it makes no assumptions about its host environment. Thus, it makes sense to think that _Wasm_
will become an important "portable executable" format used in a variety of contexts in the near
 future (we will dedicate some time to take a closer look at _Wasm_'s portability features further in the book).

As of *today*, however, _Wasm_ is mostly related to JavaScript, which comes in many flavors (including both
browsers and [Node.js]). Due to JS being widespread and easy to access we will focus mostly on using these
platforms to run Rust-generated _Wasm_, but other interpreters are probably going to be released in the near future.

As a programming language, WebAssembly is comprised of two formats: The binary format and the text format.
Both represent a common structure, albeit in different ways. The text format (generally called `wat`) uses
[S-expressions], which bears some resemblance to languages like Clojure or Racket.
The binary format `wasm` is a lower-level format, being itself the assembly code which is run by the interpreters.

For reference, here is a factorial function in `wat`:

```wasm
(module
  (func $fac (param f64) (result f64)
    get_local 0
    f64.const 1
    f64.lt
    if (result f64)
      f64.const 1
    else
      get_local 0
      get_local 0
      f64.const 1
      f64.sub
      call $fac
      f64.mul
    end)
  (export "fac" (func $fac)))
```

If you're curious about how a `wasm` file looks like you can use [wat2wasm demo] with the above code.

WebAssembly has a very simple [memory model]. At the moment, a Wasm module has access to a single
"linear memory", which is essentially a flat array of a fixed
numeric type. This [memory can be grown] by a multiple of the page size (64K),
and cannot be shrunk.

[memory model]: https://webassembly.github.io/spec/core/syntax/modules.html#syntax-mem
[memory can be grown]: https://webassembly.github.io/spec/core/syntax/instructions.html#syntax-instr-memory
[extensive specification]: https://webassembly.github.io/spec/
[value types]: https://webassembly.github.io/spec/core/syntax/types.html#value-types
[Node.js]: https://nodejs.org
[S-expressions]: https://en.wikipedia.org/wiki/S-expression
[wat2wasm demo]: https://cdn.rawgit.com/WebAssembly/wabt/aae5a4b7/demo/wat2wasm/
