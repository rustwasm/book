# How to Add WebAssembly Support to a General-Purpose Crate

This section is for general-purpose crate authors who want to support
WebAssembly.

## Maybe Your Crate Already Supports WebAssembly!

Review the information about [what kinds of things can make a general-purpose
crate *not* portable for WebAssembly](./which-crates-work-with-wasm.html). If
your crate doesn't have any of those things, it likely already supports
WebAssembly!

You can always check by running `cargo build` for the WebAssembly target:

```
cargo build --target wasm32-unknown-unknown
```

If that command fails, then your crate doesn't support WebAssembly right now. If
it doesn't fail, then your crate *might* support WebAssembly. You can be 100%
sure that it does (and continues to do so!) by [adding tests for wasm and
running those tests in CI.](#maintaining-ongoing-support-for-webassembly)

## Adding Support for WebAssembly

### Avoid Performing I/O Directly

On the Web, I/O is always asynchronous, and there isn't a file system. Factor
I/O out of your library, let users perform the I/O and then pass the input
slices to your library instead.

For example, refactor this:

```rust
use std::fs;
use std::path::Path;

pub fn parse_thing(path: &Path) -> Result<MyThing, MyError> {
    let contents = fs::read(path)?;
    // ...
}
```

Into this:

```rust
pub fn parse_thing(contents: &[u8]) -> Result<MyThing, MyError> {
    // ...
}
```

### Add `wasm-bindgen` as a Dependency

If you need to interact with the outside world (i.e. you can't have library
consumers drive that interaction for you) then you'll need to add `wasm-bindgen`
(and `js-sys` and `web-sys` if you need them) as a dependency for when
compilation is targeting WebAssembly:

```toml
[target.'cfg(target_arch = "wasm32")'.dependencies]
wasm-bindgen = "0.2"
js-sys = "0.3"
web-sys = "0.3"
```

### Avoid Synchronous I/O

If you must perform I/O in your library, then it cannot be synchronous. There is
only asynchronous I/O on the Web. Use [the `futures`
crate](https://crates.io/crates/futures) and [the `wasm-bindgen-futures`
crate](https://rustwasm.github.io/wasm-bindgen/api/wasm_bindgen_futures/) to
manage asynchronous I/O. If your library functions are generic over some
future type `F`, then that future can be implemented via `fetch` on the Web or
via non-blocking I/O provided by the operating system.

```rust
pub fn do_stuff<F>(future: F) -> impl Future<Item = MyOtherThing>
where
    F: Future<Item = MyThing>,
{
    // ...
}
```

You can also define a trait and implement it for WebAssembly and the Web and
also for native targets:

```rust
trait ReadMyThing {
    type F: Future<Item = MyThing>;
    fn read(&self) -> Self::F;
}

#[cfg(target_arch = "wasm32")]
struct WebReadMyThing {
    // ...
}

#[cfg(target_arch = "wasm32")]
impl ReadMyThing for WebReadMyThing {
    // ...
}

#[cfg(not(target_arch = "wasm32"))]
struct NativeReadMyThing {
    // ...
}

#[cfg(not(target_arch = "wasm32"))]
impl ReadMyThing for NativeReadMyThing {
    // ...
}
```

### Avoid Spawning Threads

Wasm doesn't support threads yet (but [experimental work is
ongoing](https://rustwasm.github.io/2018/10/24/multithreading-rust-and-wasm.html)),
so attempts to spawn threads in wasm will panic.

You can use `#[cfg(..)]`s to enable threaded and non-threaded code paths
depending on if the target is WebAssembly or not:

```rust
#![cfg(target_arch = "wasm32")]
fn do_work() {
    // Do work with only this thread...
}

#![cfg(not(target_arch = "wasm32"))]
fn do_work() {
    use std::thread;

    // Spread work to helper threads....
    thread::spawn(|| {
        // ...
    });
}
```

Another option is to factor out thread spawning from your library and allow
users to "bring their own threads" similar to factoring out file I/O and
allowing users to bring their own I/O. This has the side effect of playing nice
with applications that want to own their own custom thread pool.

## Maintaining Ongoing Support for WebAssembly

### Building for `wasm32-unknown-unknown` in CI

Ensure that compilation doesn't fail when targeting WebAssembly by having your
CI script run these commands:

```
rustup target add wasm32-unknown-unknown
cargo check --target wasm32-unknown-unknown
```

For example, you can add this to your `.travis.yml` configuration for Travis CI:

```yaml

matrix:
  include:
    - language: rust
      rust: stable
      name: "check wasm32 support"
      install: rustup target add wasm32-unknown-unknown
      script: cargo check --target wasm32-unknown-unknown
```

### Testing in Node.js and Headless Browsers

You can use `wasm-bindgen-test` and the `wasm-pack test` subcommand to run wasm
tests in either Node.js or a headless browser. You can even integrate these
tests into your CI.

[Learn more about testing wasm
here.](https://rustwasm.github.io/wasm-bindgen/wasm-bindgen-test/index.html)
