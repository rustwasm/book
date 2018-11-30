# Shrinking `.wasm` Size

For `.wasm` binaries that we ship to clients over the network, such as our Game
of Life Web application, we want to keep an eye on code size. The smaller our
`.wasm` is, the faster our page loads get, and the happier our users are.

## How small can we get our Game of Life `.wasm` binary via build configuration?

[Take a moment to review the build configuration options we can tweak to get
smaller `.wasm` code
sizes.](../reference/code-size.html#optimizing-builds-for-code-size)

With the default release build configuration (without debug symbols), our
WebAssembly binary is 29,410 bytes:

```
$ wc -c pkg/wasm_game_of_life_bg.wasm
29410 pkg/wasm_game_of_life_bg.wasm
```

After enabling LTO, setting `opt-level = "z"`, and running `wasm-opt -Oz`, the
resulting `.wasm` binary shrinks to only 17,317 bytes:

```
$ wc -c pkg/wasm_game_of_life_bg.wasm
17317 pkg/wasm_game_of_life_bg.wasm
```

And if we compress it with `gzip` (which nearly every HTTP server does) we get
down to a measly 9,045 bytes!

```
$ gzip -9 < pkg/wasm_game_of_life_bg.wasm | wc -c
9045
```

## Exercises

* Use [the `wasm-snip` tool](../reference/code-size.html#use-the-wasm-snip-tool)
  to remove the panicking infrastructure functions from our Game of Life's
  `.wasm` binary. How many bytes does it save?

* Build our Game of Life crate with and without [`wee_alloc` as its global
  allocator](https://github.com/rustwasm/wee_alloc). The
  `rustwasm/wasm-pack-template` template that we cloned to start this project
  has a "wee_alloc" cargo feature that you can enable by adding it to the
  `default` key in the `[features]` section of `wasm-game-of-life/Cargo.toml`:

  ```toml
  [features]
  default = ["wee_alloc"]
  ```

  How much size does using `wee_alloc` shave off of the `.wasm`
  binary?

* We only ever instantiate a single `Universe`, so rather than providing a
  constructor, we can export operations that manipulate a single `static mut`
  global instance. If this global instance also uses the double buffering
  technique discussed in earlier chapters, we can make those buffers also be
  `static mut` globals. This removes all dynamic allocation from our Game of
  Life implementation, and we can make it a `#![no_std]` crate that doesn't
  include an allocator. How much size was removed from the `.wasm` by completely
  removing the allocator dependency?
