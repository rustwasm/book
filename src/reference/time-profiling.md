# Time Profiling

This section describes how to profile Web pages using Rust and WebAssembly where
the goal is improving throughput or latency.

> ⚡ Always make sure you are using an optimized build when profiling! `wasm-pack
> build` will build with optimizations by default.

## Available Tools

### The `window.performance.now()` Timer

[The `performance.now()` function][perf-now] returns a monotonic timestamp
measured in milliseconds since the Web page was loaded.

Calling `performance.now` has little overhead, so we can create simple, granular
measurements from it without distorting the performance of the rest of the
system and inflicting bias upon our measurements.

We can use it to time various operations, and we can access
`window.performance.now()` via [the `web-sys` crate][web-sys]:

```rust
extern crate web_sys;

fn now() -> f64 {
    web_sys::window()
        .expect("should have a Window")
        .performance()
        .expect("should have a Performance")
        .now()
}
```

* [The `web_sys::window` function](https://rustwasm.github.io/wasm-bindgen/api/web_sys/fn.window.html)
* [The `web_sys::Window::performance` method](https://rustwasm.github.io/wasm-bindgen/api/web_sys/struct.Window.html#method.performance)
* [The `web_sys::Performance::now` method](https://rustwasm.github.io/wasm-bindgen/api/web_sys/struct.Performance.html#method.now)

[perf-now]: https://developer.mozilla.org/en-US/docs/Web/API/Performance/now

### Developer Tools Profilers

All Web browsers' built-in developer tools include a profiler. These profilers
display which functions are taking the most time with the usual kinds of
visualizations like call trees and flame graphs.

If you [build with debug symbols][symbols] so that the "name" custom section is
included in the wasm binary, then these profilers should display the Rust
function names instead of something opaque like `wasm-function[123]`.

Note that these profilers *won't* show inlined functions, and since Rust and
LLVM rely on inlining so heavily, the results might still end up a bit
perplexing.

[symbols]: ./debugging.html#building-with-debug-symbols

[![Screenshot of profiler with Rust symbols](../images/game-of-life/profiler-with-rust-names.png)](../images/game-of-life/profiler-with-rust-names.png)

#### Resources

* [Firefox Developer Tools — Performance](https://developer.mozilla.org/en-US/docs/Tools/Performance)
* [Microsoft Edge Developer Tools — Performance](https://docs.microsoft.com/en-us/microsoft-edge/devtools-guide/performance)
* [Chrome DevTools JavaScript Profiler](https://developers.google.com/web/tools/chrome-devtools/rendering-tools/js-execution)

### The `console.time` and `console.timeEnd` Functions

[The `console.time` and `console.timeEnd` functions][console-time] allow you to
log the timing of named operations to the browser's developer tools console. You
call `console.time("some operation")` when the operation begins, and call
`console.timeEnd("some operation")` when it finishes. The string label naming
the operation is optional.

You can use these functions directly via [the `web-sys` crate][web-sys]:

* [`web_sys::console::time_with_label("some
  operation")`](https://rustwasm.github.io/wasm-bindgen/api/web_sys/console/fn.time_with_label.html)
* [`web_sys::console::time_end_with_label("some
  operation")`](https://rustwasm.github.io/wasm-bindgen/api/web_sys/console/fn.time_end_with_label.html)

Here is a screenshot of `console.time` logs in the browser's console:

[![Screenshot of console.time logs](../images/game-of-life/console-time.png)](../images/game-of-life/console-time.png)

Additionally, `console.time` and `console.timeEnd` logs will show up in your
browser's profiler's "timeline" or "waterfall" view:

[![Screenshot of console.time logs](../images/game-of-life/console-time-in-profiler.png)](../images/game-of-life/console-time-in-profiler.png)

[console-time]: https://developer.mozilla.org/en-US/docs/Web/API/Console/time

### Using `#[bench]` with Native Code

The same way we can often leverage our operating system's native code debugging
tools by writing `#[test]`s rather than debugging on the Web, we can leverage
our operating system's native code profiling tools by writing `#[bench]`
functions.

Write your benchmarks in the `benches` subdirectory of your crate. Make sure
that your `crate-type` includes `"rlib"` or else the bench binaries won't be
able to link your main lib.

However! Make sure that you know the bottleneck is in the WebAssembly before
investing much energy in native code profiling! Use your browser's profiler to
confirm this, or else you risk wasting your time optimizing code that isn't hot.

#### Resources

* [Using the `perf` profiler on Linux](http://www.brendangregg.com/perf.html)
* [Using the Instruments.app profiler on macOS](https://help.apple.com/instruments/mac/current/)
* [The VTune profiler supports Windows and Linux](https://software.intel.com/en-us/vtune)

[web-sys]: https://rustwasm.github.io/wasm-bindgen/web-sys/index.html
