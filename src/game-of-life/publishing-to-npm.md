# Publishing to npm

Now that we have a working, fast, *and* small `wasm-game-of-life` package, we
can publish it to npm so other JavaScript developers can reuse it, if they ever
need an off-the-shelf Game of Life implementation.

## Prerequisites

First, [make sure you have an npm account](https://www.npmjs.com/signup).

Second, make sure you are logged into your account locally, by running this
command:

```
wasm-pack login
```

## Publishing

Make sure that the `wasm-game-of-life/pkg` build is up to date by running
`wasm-pack` inside the `wasm-game-of-life` directory:

```
wasm-pack build
```

Take a moment to check out the contents of `wasm-game-of-life/pkg` now, this is
what we are publishing to npm in the next step!

When you're ready, run `wasm-pack publish` to upload the package to npm:

```
wasm-pack publish
```

That's all it takes to publish to npm!

...except other folks have also done this tutorial, and therefore the
`wasm-game-of-life` name is taken on npm, and that last command probably didn't
work.

Open up `wasm-game-of-life/Cargo.toml` and add your username to the end of the
`name` to disambiguate the package in a unique way:

```toml
[package]
name = "wasm-game-of-life-my-username"
```

Then, rebuild and publish again:

```
wasm-pack build
wasm-pack publish
```

This time it should work!
