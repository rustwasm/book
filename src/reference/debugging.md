# Debugging Rust-Generated WebAssembly

This section contains tips for debugging Rust-generated WebAssembly.

## Building with Debug Symbols

> ⚡ When debugging, always make sure you are building with debug symbols!

If you don't have debug symbols enabled, then the `"name"` custom section won't
be present in the compiled `.wasm` binary, and stack traces will have function
names like `wasm-function[42]` rather than the Rust name of the function, like
`wasm_game_of_life::Universe::live_neighbor_count`.

When using a "debug" build (aka `wasm-pack build --debug` or `cargo build`)
debug symbols are enabled by default.

With a "release" build, debug symbols are not enabled by default. To enable
debug symbols, ensure that you `debug = true` in the `[profile.release]` section
of your `Cargo.toml`:

```toml
[profile.release]
debug = true
```

## Logging with the `console` APIs

Logging is one of the most effective tools we have for proving and disproving
hypotheses about why our programs are buggy. On the Web, [the `console.log`
function](https://developer.mozilla.org/en-US/docs/Web/API/Console/log) is the
way to log messages to the browser's developer tools console.

We can use [the `web-sys` crate][web-sys] to get access to the `console` logging
functions:

```rust
extern crate web_sys;

web_sys::console::log_1(&"Hello, world!".into());
```

Alternatively, [the `console.error`
function](https://developer.mozilla.org/en-US/docs/Web/API/Console/error) has
the same signature as `console.log`, but developer tools tend to also capture
and display a stack trace alongside the logged message when `console.error` is
used.

### References

* Using `console.log` with the `web-sys` crate:
  * [`web_sys::console::log` takes an array of values to log](https://rustwasm.github.io/wasm-bindgen/api/web_sys/console/fn.log.html)
  * [`web_sys::console::log_1` logs a single value](https://rustwasm.github.io/wasm-bindgen/api/web_sys/console/fn.log_1.html)
  * [`web_sys::console::log_2` logs two values](https://rustwasm.github.io/wasm-bindgen/api/web_sys/console/fn.log_2.html)
  * Etc...
* Using `console.error` with the `web-sys` crate:
  * [`web_sys::console::error` takes an array of values to log](https://rustwasm.github.io/wasm-bindgen/api/web_sys/console/fn.error.html)
  * [`web_sys::console::error_1` logs a single value](https://rustwasm.github.io/wasm-bindgen/api/web_sys/console/fn.error_1.html)
  * [`web_sys::console::error_2` logs two values](https://rustwasm.github.io/wasm-bindgen/api/web_sys/console/fn.error_2.html)
  * Etc...
* [The `console` object on MDN](https://developer.mozilla.org/en-US/docs/Web/API/Console)
* [Firefox Developer Tools — Web Console](https://developer.mozilla.org/en-US/docs/Tools/Web_Console)
* [Microsoft Edge Developer Tools — Console](https://docs.microsoft.com/en-us/microsoft-edge/devtools-guide/console)
* [Get Started with the Chrome DevTools Console](https://developers.google.com/web/tools/chrome-devtools/console/get-started)

## Logging Panics

[The `console_error_panic_hook` crate logs unexpected panics to the developer
console via `console.error`.][panic-hook] Rather than getting cryptic,
difficult-to-debug `RuntimeError: unreachable executed` error messages, this
gives you Rust's formatted panic message.

All you need to do is install the hook by calling
`console_error_panic_hook::set_once()` in an initialization function or common
code path:

```rust
#[wasm_bindgen]
pub fn init_panic_hook() {
    console_error_panic_hook::set_once();
}
```

[panic-hook]: https://github.com/rustwasm/console_error_panic_hook

## Using a Debugger

Unfortunately, the debugging story for WebAssembly is still immature. On most
Unix systems, [DWARF][dwarf] is used to encode the information that a debugger
needs to provide source-level inspection of a running program. There is an
alternative format that encodes similar information on Windows. Currently, there
is no equivalent for WebAssembly. Therefore, debuggers currently provide limited
utility, and we end up stepping through raw WebAssembly instructions emitted by
the compiler, rather than the Rust source text we authored.

> There is a [sub-charter of the W3C WebAssembly group for
> debugging][debugging-subcharter], so expect this story to improve in the
> future!

[debugging-subcharter]: https://github.com/WebAssembly/debugging
[dwarf]: http://dwarfstd.org/

Nonetheless, debuggers are still useful for inspecting the JavaScript that
interacts with our WebAssembly, and inspecting raw wasm state.

### References

* [Firefox Developer Tools — Debugger](https://developer.mozilla.org/en-US/docs/Tools/Debugger)
* [Microsoft Edge Developer Tools — Debugger](https://docs.microsoft.com/en-us/microsoft-edge/devtools-guide/debugger)
* [Get Started with Debugging JavaScript in Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools/javascript/)

## Avoid the Need to Debug WebAssembly in the First Place

If the bug is specific to interactions with JavaScript or Web APIs, then [write
tests with `wasm-bindgen-test`.][wbg-test]

If a bug does *not* involve interaction with JavaScript or Web APIs, then try to
reproduce it as a normal Rust `#[test]` function, where you can leverage your
OS's mature native tooling when debugging. Use testing crates like
[`quickcheck`][quickcheck] and its test case shrinkers to mechanically reduce
test cases. Ultimately, you will have an easier time finding and fixing bugs if
you can isolate them in a smaller test cases that don't require interacting with
JavaScript.

Note that in order to run native `#[test]`s without compiler and linker errors,
you will need to ensure that `"rlib"` is included in the `[lib.crate-type]`
array in your `Cargo.toml` file.

```toml
[lib]
crate-type ["cdylib", "rlib"]
```

[quickcheck]: https://crates.io/crates/quickcheck
[web-sys]: https://rustwasm.github.io/wasm-bindgen/web-sys/index.html
[wbg-test]: https://rustwasm.github.io/wasm-bindgen/wasm-bindgen-test/index.html
