# Introduction

`wasm-pack` is a brand new tool designed to make packaging up wasm binaries and distributing them
on npm easy to do. We can't necessarily distribute Rust code to developers directly and expect them
to build it from scratch. npm is about installing the packages and importing them, not also
compiling them. With wasm though it's not a problem. Once it's compiled it's all good to go.
However, getting it ready to be distributed, packaging it up properly for npm, and then sending it
to npm can be a bit of a hassle. `wasm-pack` is here to make that easier.

We'll step through creating a simple Rust library, using `wasm-pack` to get it ready for
distribution, sending it to npm, then using it as a package from npm to verify it works!

As with all software in the early stages this is bleeding edge! Expect some nicks and bruises! If
you run into issues or a bug please file an issue over at it's [repo].

[repo]: https://github.com/ashleygwilliams/wasm-pack/issues
