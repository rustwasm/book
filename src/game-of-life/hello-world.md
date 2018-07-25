# Hello, World!

This section will show you how to build and run your first Rust and WebAssembly
program: a Web page that alerts "Hello, World!"

## Clone the Project Template

The project template contains a "hello world" program. It comes pre-configured
with sane defaults, so you can quickly build, integrate, and package your code
for the Web.

Clone this tutorials code repository, enter its directory, and checkout the
`chapter-zero` branch:

```text
git clone https://github.com/rustwasm/wasm_game_of_life.git
cd ./wasm_game_of_life
git checkout -b chapter-zero origin/chapter-zero
```

## What's Inside

Let's take a look at the contents of our project:

```text
.
├── bootstrap.js
├── Cargo.lock
├── Cargo.toml
├── index.html
├── index.js
├── package.json
├── package-lock.json
├── src
│   └── lib.rs
└── webpack.config.js
```

Most of these are configuration files, but there are a few files we should
highlight.

### `index.html`

This is the root HTML file for the the Web page. It doesn't do much other than
load `bootstrap.js`, which is a very thin wrapper around `index.js`.

```html
<html>
    <head>
        <meta content="text/html;charset=utf-8" http-equiv="Content-Type"/>
    </head>
    <body>
        <script src='./bootstrap.js'></script>
    </body>
</html>
```

### `index.js`

The `index.js` is the main entry point for our Web page's JavaScript. It imports
the project's WebAssembly module, and calls the module's `greet` function.

```js
import { greet } from "./wasm_game_of_life";

greet("Rust and WebAssembly");
```

### `src/lib.rs`

The `src/lib.rs` file is the root of the Rust crate that we are compiling to
WebAssembly. It uses `wasm_bindgen` to interface with JavaScript. It imports the
`window.alert` JavaScript function, and exports the `greet` Rust function, which
takes a `name` parameter and alerts a greeting message.

```rust
#![feature(use_extern_macros)]

extern crate wasm_bindgen;

use wasm_bindgen::prelude::*;

#[wasm_bindgen]
extern {
    fn alert(s: &str);
}

#[wasm_bindgen]
pub fn greet(name: &str) {
    alert(&format!("Hello, {}!", name));
}
```

## Building and Serving

First, ensure that the JavaScript build dependencies are installed for this
project:

```text
npm install
```

This command only needs to be run once, and will install the `webpack`
JavaScript bundler and its development server. Note that `webpack` is not
required for working with Rust and WebAssembly, it is just the bundler and
development server we've chosen for convenience here.

To build the Rust crate as WebAssembly and generate the `wasm_bindgen` glue, run
this command:

```text
npm run build-debug
```

The first build may take a little while, since dependencies need to be compiled.
But don't worry: subsequent builds, when dependencies don't need to be
recompiled, will be much faster.

This creates a "debug" build of the Rust crates: a build that does not have
optimizations applied, and has symbols included for better debugging in your
browser's developer tools. You can also create a "release" build that has
optimization passes applied with this command:

```
npm run build-release
```

This is the command we want to use to create `.wasm` binaries for profiling and
deploying to production.

Next, open a new terminal for the development server. Running the server in a
new terminal lets us leave it running in the background, and doesn't block us
from running other commands in the meantime. In the new terminal, run this
command:

```
npm run serve
```

Navigate your Web browser to [http://localhost:8080/](http://localhost:8080/)
and you should be greeted with an alert message:

[![Screenshot of the "Hello, Rust and WebAssembly!" Web page alert](./images/game-of-life/setup.png)](./images/game-of-life/setup.png)

Anytime you make changes and want them reflected on
[http://localhost:8080/](http://localhost:8080/), just re-run the `npm run
build-debug`
command.

## Exercises

* Modify `index.js` to greet you by your name instead of by "Rust and WebAssembly".
