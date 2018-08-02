# Tutorial: Conway's Game of Life

This is a tutorial that implements [Conway's Game of Life][gol] in Rust and
WebAssembly.

[gol]: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life

## Who is this tutorial for?

This tutorial is for anyone who already has basic Rust and JavaScript
experience, and wants to learn how to use Rust, WebAssembly, and JavaScript
together.

You should be comfortable reading and writing basic Rust, JavaScript, and
HTML. You definitely do not need to be an expert.

## What will I learn?

* How to set up a Rust toolchain for compiling to WebAssembly.

* A workflow for developing polyglot programs made from Rust, WebAssembly,
  JavaScript, HTML, and CSS.

* How to design APIs to take maximum advantage of both Rust and WebAssembly's
  strengths and also JavaScript's strengths.

* How to debug WebAssembly modules compiled from Rust.

* How to time profile Rust and WebAssembly programs to make them faster.

* How to size profile Rust and WebAssembly programs to make `.wasm` binaries
  smaller and faster to download over the network.
