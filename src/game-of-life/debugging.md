# Debugging

Before we write much more code, we will want to have some debugging tools in our
belt for when things go wrong.

## Building with Debug Symbols

> ⚡ When debugging, always make sure you are building with debug symbols!

If you don't have debug symbols enabled, then the `"name"` section won't be
present in the compiled `.wasm` binary, and stack traces will have function
names like `wasm[42]` rather than
`wasm_game_of_life::Universe::live_neighbor_count`.

When using a "debug" build (aka `npm run build-debug`) debug symbols are enabled
by default.

With a "release" build, debug symbols are not enabled by default. To enable
debug symbols, ensure that you `debug = true` in the `[profile.release]` section
of your `Cargo.toml`:

```toml
[profile.release]
debug = true
```

The project template we've been working with adds this to `Cargo.toml` by
default, for convenience.

## Logging

Logging is one of the most effective tools we have for proving and disproving
hypotheses about why our programs are buggy. On the Web, the `console.log`
function is the way to log messages to the browser's developer tools console. We
can use `wasm_bindgen` to import a reference to it, like this:

```rust
#[wasm_bindgen]
extern {
    #[wasm_bindgen(js_namespace = console)]
    fn log(msg: &str);
}

// A macro to provide `println!(..)`-style syntax for `console.log` logging.
macro_rules! log {
    ($($t:tt)*) => (log(&format!($($t)*)))
}
```

Then, we can start logging messages to the console by inserting calls to `log`
in Rust code. For example, to log each cell's state, live neighbors count, and
next state, we could modify our code like this:

```diff
diff --git a/src/lib.rs b/src/lib.rs
index f757641..a30e107 100755
--- a/src/lib.rs
+++ b/src/lib.rs
@@ -63,6 +63,11 @@ impl Universe {
                 let cell = self.cells[idx];
                 let live_neighbors = self.live_neighbor_count(row, col);

+                log!(
+                    "cell[{}, {}] is initially {:?} and has {} live neighbors",
+                    row, col, cell, live_neighbors
+                );
+
                 let next_cell = match (cell, live_neighbors) {
                     // Rule 1: Any live cell with fewer than two live neighbours
                     // dies, as if caused by underpopulation.
@@ -80,6 +85,8 @@ impl Universe {
                     (otherwise, _) => otherwise,
                 };

+                log!("    it becomes {:?}", next_cell);
+
                 next[idx] = next_cell;
             }
         }
```

Alternatively, the `console.error` function has the same interface as
`console.log`, but developer tools tend to also capture and display a stack
trace alongside the logged message when `console.error` is used.

### References

* [The `console` object](https://developer.mozilla.org/en-US/docs/Web/API/Console)
* [Firefox Developer Tools — Web Console](https://developer.mozilla.org/en-US/docs/Tools/Web_Console)
* [Microsoft Edge Developer Tools — Console](https://docs.microsoft.com/en-us/microsoft-edge/devtools-guide/console)
* [Get Started with the Chrome DevTools Console](https://developers.google.com/web/tools/chrome-devtools/console/get-started)

## Using a Debugger

Unfortunately, the debugging story for WebAssembly is still immature. On most
Unix systems, [DWARF][dwarf] is used to encode the information that a debugger
needs to provide source-level inspection of a running program. There is an
alternative format that encodes similar information on Windows. Currently, there
is no equivalent for WebAssembly. Therefore, debuggers currently provide limited
utility, and we end up stepping through raw WebAssembly instructions emitted by
the compiler, rather than the Rust source text we authored.

Nonetheless, debuggers are still useful for inspecting the JavaScript that
interacts with our WebAssembly. For example, we can use the debugger to pause on
each iteration of our `renderLoop` function. This provides us with a convenient
checkpoint for inspecting logged messages, and comparing the currently rendered
frame to the previous one.

[dwarf]: http://dwarfstd.org/

[![Screenshot of debugging the Game of Life](/images/game-of-life/debugging.png)](/images/game-of-life/debugging.png)

### References

* [Firefox Developer Tools — Debugger](https://developer.mozilla.org/en-US/docs/Tools/Debugger)
* [Microsoft Edge Developer Tools — Debugger](https://docs.microsoft.com/en-us/microsoft-edge/devtools-guide/debugger)
* [Get Started with Debugging JavaScript in Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools/javascript/)

## Avoid the Need to Debug WebAssembly in the First Place

While some bugs are specific to interfaceing JavaScript and WebAssembly,
experience says that most are not. Try to reproduce bugs as normal Rust
`#[test]` functions, where you can leverage your OS's mature native tooling when
debugging. Use testing crates like [`quickcheck`][quickcheck] to exercise the
interface you expose to JavaScript. Ultimately, you will have an easier time
finding and fixing bugs if you can isolate them in a smaller test cases that
don't require interacting with JavaScript.

Note that in order to run the `#[test]`s without compiler and linker errors, you
will need to comment out the `#![wasm_bindgen]` annotations and `crate-type =
"cdylib"` bits.

[quickcheck]: https://crates.io/crates/quickcheck

## Exercises

* Add logging to the `tick` function that records the row and column of each
  cell that transitioned states from live to dead or vice versa.

* Introduce a `panic!()` in the `Universe::new` method. Inspect the panic's
  backtrace in your Web browser's JavaScript debugger. Disable debug symbols,
  rebuild, and inspect the stack trace again. Not as useful, is it?

* Checkout the `chapter-one-with-bug` branch. Rebuild and reload the Web
  page. It should now be obvious that this branch's implementation contains a
  bug, and every cell is apparently alive. This is a Real World(tm) bug that
  your author made when initially creating the example code. Find the bug and
  fix it. *Don't look at the commit history! That's cheating ;-)*
