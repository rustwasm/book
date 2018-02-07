# Background and Concepts

## Web Assembly
WebAssembly is a simple machine model and executable format with an [extensive
specification].

Although currently it has gathered attention in the JavaScript and web communities in general, it makes no assumptions about its host environment. Thus, it makes sense to think that _wasm_ will become an important "portable executable" format used in a variety of contexts in the near future (we will dedicate some time to have a closer look at _wasm_'s portability features further in the book).

As of *today*, however, _wasm_ is mostly related to JavaScript, which comes in many flavors (including both browsers and [Node.js]). Due to JS being widespread and easy to access we will focus mostly on using these platforms to run Rust-generated _wasm_, but other intepreters are probably going to be released in the near future.

As a programming language, WebAssembly is comprised of two formats: The binary format and the text format. Both represent a common structure, albeit in different ways. The text format (generally called `wat`) uses [S-expressions], which bears some resemblance to languages like Clojure or Racket.
The binary format, (`wasm`) as the name implies, is a lower level format, being itself the assembly code which is ran by the intepreters.

To illustrate the difference between them, here is a factorial function in `wat`:

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

Here is the same code, now in `wasm` :
```
0000000: 0061 736d                                 ; WASM_BINARY_MAGIC
0000004: 0100 0000                                 ; WASM_BINARY_VERSION
; section "Type" (1)
0000008: 01                                        ; section code
0000009: 00                                        ; section size (guess)
000000a: 01                                        ; num types
; type 0
000000b: 60                                        ; func
000000c: 01                                        ; num params
000000d: 7c                                        ; f64
000000e: 01                                        ; num results
000000f: 7c                                        ; f64
0000009: 06                                        ; FIXUP section size
; section "Function" (3)
0000010: 03                                        ; section code
0000011: 00                                        ; section size (guess)
0000012: 01                                        ; num functions
0000013: 00                                        ; function 0 signature index
0000011: 02                                        ; FIXUP section size
; section "Export" (7)
0000014: 07                                        ; section code
0000015: 00                                        ; section size (guess)
0000016: 01                                        ; num exports
0000017: 03                                        ; string length
0000018: 6661 63                                  fac  ; export name
000001b: 00                                        ; export kind
000001c: 00                                        ; export func index
0000015: 07                                        ; FIXUP section size
; section "Code" (10)
000001d: 0a                                        ; section code
000001e: 00                                        ; section size (guess)
000001f: 01                                        ; num functions
; function body 0
0000020: 00                                        ; func body size (guess)
0000021: 00                                        ; local decl count
0000022: 20                                        ; get_local
0000023: 00                                        ; local index
0000024: 44                                        ; f64.const
0000025: 0000 0000 0000 f03f                       ; f64 literal
000002d: 63                                        ; f64.lt
000002e: 04                                        ; if
000002f: 7c                                        ; f64
0000030: 44                                        ; f64.const
0000031: 0000 0000 0000 f03f                       ; f64 literal
0000039: 05                                        ; else
000003a: 20                                        ; get_local
000003b: 00                                        ; local index
000003c: 20                                        ; get_local
000003d: 00                                        ; local index
000003e: 44                                        ; f64.const
000003f: 0000 0000 0000 f03f                       ; f64 literal
0000047: a1                                        ; f64.sub
0000048: 10                                        ; call
0000049: 00                                        ; function index
000004a: a2                                        ; f64.mul
000004b: 0b                                        ; end
000004c: 0b                                        ; end
0000020: 2c                                        ; FIXUP func body size
000001e: 2e                                        ; FIXUP section size
; section "name"
000004d: 00                                        ; section code
000004e: 00                                        ; section size (guess)
000004f: 04                                        ; string length
0000050: 6e61 6d65                                name  ; custom section name
0000054: 01                                        ; function name type
0000055: 00                                        ; subsection size (guess)
0000056: 01                                        ; num functions
0000057: 00                                        ; function index
0000058: 03                                        ; string length
0000059: 6661 63                                  fac  ; func name 0
0000055: 06                                        ; FIXUP subsection size
000005c: 02                                        ; local name type
000005d: 00                                        ; subsection size (guess)
000005e: 01                                        ; num functions
000005f: 00                                        ; function index
0000060: 01                                        ; num locals
0000061: 00                                        ; local index
0000062: 00                                        ; string length
000005d: 05                                        ; FIXUP subsection size
000004e: 14                                        ; FIXUP section size
BUILD LOG

``` 


WebAssembly has a very simple [memory model]. At the moment, a wasm module has access to a single "linear memory", which is essentially a flat array of a fixed
numeric type. This [memory can be grown] by a multiple of the page size (64K),
and cannot be shrunk.

[memory model]: https://webassembly.github.io/spec/core/syntax/modules.html#syntax-mem
[memory can be grown]: https://webassembly.github.io/spec/core/syntax/instructions.html#syntax-instr-memory
[extensive specification]: https://webassembly.github.io/spec/
[value types]: https://webassembly.github.io/spec/core/syntax/types.html#value-types
[Node.js]:[https://nodejs.org]
[S-expressions]:[https://en.wikipedia.org/wiki/S-expression]
