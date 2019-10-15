# What is WebAssembly?

WebAssembly (wasm) is a simple machine model and executable format with an
[extensive specification]. It is designed to be portable, compact, and execute
at or near native speeds.

As a programming language, WebAssembly is comprised of two formats that
represent the same structures, albeit in different ways:

1. The `.wat` text format (called `wat` for "**W**eb**A**ssembly **T**ext") uses
   [S-expressions], and bears some resemblance to the Lisp family of languages
   like Scheme and Clojure.

2. The `.wasm` binary format is lower-level and intended for consumption
   directly by wasm virtual machines. It is conceptually similar to ELF and
   Mach-O.

For reference, here is a factorial function in `wat`:

```
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

If you're curious about what a `wasm` file looks like you can use the [wat2wasm
demo] with the above code.

## Linear Memory

WebAssembly has a very simple [memory model]. A wasm module has access to a
single "linear memory", which is essentially a flat array of bytes. This
[memory can be grown] by a multiple of the page size (64K). It cannot be shrunk.

## Is WebAssembly Just for the Web?

Although it has currently gathered attention in the JavaScript and Web
communities in general, wasm makes no assumptions about its host
environment. Thus, it makes sense to speculate that wasm will become a "portable
executable" format that is used in a variety of contexts in the future. As of
*today*, however, wasm is mostly related to JavaScript (JS), which comes in many
flavors (including both on the Web and [Node.js]).

[memory model]: https://webassembly.github.io/spec/core/syntax/modules.html#syntax-mem
[memory can be grown]: https://webassembly.github.io/spec/core/syntax/instructions.html#syntax-instr-memory
[extensive specification]: https://webassembly.github.io/spec/
[value types]: https://webassembly.github.io/spec/core/syntax/types.html#value-types
[Node.js]: https://nodejs.org
[S-expressions]: https://en.wikipedia.org/wiki/S-expression
[wat2wasm demo]: https://webassembly.github.io/wabt/demo/wat2wasm/
