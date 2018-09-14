# Why Rust and WebAssembly?

## Low-Level Control with High-Level Ergonomics

JavaScript Web applications struggle to attain and retain reliable performance.
JavaScript's dynamic type system and garbage collection pauses don't help.
Seemingly small code changes can result in drastic performance regressions if
you accidentally wander off the JIT's happy path.

Rust gives programmers low-level control and reliable performance. It is free
from the non-deterministic garbage collection pauses that plague JavaScript.
Programmers have control over indirection, monomorphization, and memory layout.

## Small `.wasm` Sizes

Code size is incredibly important since the `.wasm` must be downloaded over the
network. Rust lacks a runtime, enabling small `.wasm` sizes because there is no
extra bloat included like a garbage collector. You only pay (in code size) for
the functions you actually use.

## Do *Not* Rewrite Everything

Existing code bases don't need to be thrown away. You can start by porting your
most performance-sensitive JavaScript functions to Rust to gain immediate
benefits. And you can even stop there if you want to.

## Plays Well With Others

Rust and WebAssembly integrates with existing JavaScript tooling. It supports
ECMAScript modules and you can continue using the tooling you already love, like
npm, Webpack, and Greenkeeper.

## The Amenities You Expect

Rust has the modern amenities that developers have come to expect, such as:

* strong package management with `cargo`,

* expressive (and zero-cost) abstractions,

* and a welcoming community! 😊
