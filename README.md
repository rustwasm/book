# The Rust and WebAssembly Book

This repo contains documentation on using Rust for wasm, common workflows, how
to get started and more. It acts as a guide for how to do some neat things with
it.

[Open issues for improving the Rust and WebAssembly book.][book-issues]

[Open issues related to the book from the old repository.][legacy-book-issues]
We split the book out from the rustwasm/team (ne rust-lang-nursery/rust-wasm)
repo, and a bunch of issues about the book still live there.

[book-issues]: https://github.com/rustwasm/book/issues
[legacy-book-issues]: https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+is%3Aissue+author%3Afitzgen+archived%3Afalse+user%3Arustwasm+label%3Abook

## Building the Book

The book is made using [`mdbook`][mdbook]. To install it you'll need `cargo`
installed. If you don't have any Rust tooling installed, you'll need to install
[`rustup`][rustup] first. Follow the instructions on the site in order to get
setup.

Once you have that done then just do the following:

```bash
$ cargo install mdbook
```

Make sure the `cargo install` directory is in your `$PATH` so that you can run
the binary.

Now just run this command from this directory:

```bash
$ mdbook build
```

This will build the book and output files into a directory called `book`. From
there you can navigate to the `index.html` file to view it in your browser. You
could also run the following command to automatically generate changes if you
want to look at changes you might be making to it:

```bash
$ mdbook serve
```

This will automatically generate the files as you make changes and serves them
locally so you can view them easily without having to call `build` every time.

The files are all written in Markdown so if you don't want to generate the book
to read them then you can read them from the `src` directory.

[mdbook]: https://github.com/rust-lang-nursery/mdBook
[rustup]: https://github.com/rust-lang-nursery/rustup.rs/
