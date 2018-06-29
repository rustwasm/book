# Contributing

Thank you for taking the time to look at this document, which provides some 
guidelines on making your own contributions to the `rustwasm/book` project.
If you have an idea for making this document or anything else contained in the 
`rustwasm/book` project more useful, you can help by following the steps below.

## Filing an Issue

If you're using this `book` and come across out of date information, examples 
that don't work, or anything else that's wrong, you can help by filing an issue.

### Before Filing an Issue

First, review the [Code of Conduct](
https://github.com/rustwasm/book/blob/master/CODE_OF_CONDUCT.md). Then check the
[open issues](https://github.com/rustwasm/book/issues) to see if someone is having 
the same problem as you. If they are, and you have an idea for how to fix the problem,
skip to the section below about submitting a PR! If you don't, please chime in on the
issue comment thread so that the people working on the project have a better sense of
how many people are experiencing the issue.

This is a documentation and education project, so discussion about how to improve
the experience for beginning users are particularly welcome.

### Opening the Issue on Github

You can [create a new issue here](https://github.com/rustwasm/book/issues/new).

If you're documenting a bug in one of the working code examples, it helps to 
include the following information in your issue:

```
- What did you expect to happen?
- What happened?
- What is your operating system?
- What version of Rust are you running? (`rustc --version`)
- Is there any other helpful context?
```

If the program crashed please provide a full stack trace by setting this:

  ```bash
  export RUST_BACKTRACE=full
  ```

and re-running your code so that it crashes again. Paste the output of that 
in your issue.


## Submitting a PR

Pull requests are welcome to address all issues, whether you filed them or not! If
you have an idea for contributing or a problem you want to solve, please do 
go through the process outlined above for opening an issue before you open
a pull request. It helps everyone to discuss progress on the repo collaboratively,
and to avoid duplicate work.

## Conduct

This project is a part of the [`rust-wasm` working group],an official working 
group of the Rust project. We follow the Rust 
[Code of Conduct and enforcement policies].

[`rust-wasm` working group]: https://github.com/rustwasm/team
[Code of Conduct and enforcement policies]: CODE_OF_CONDUCT.md

#### Thanks

We're excited that you're interested in Rust and WebAssembly! Thank you for 
helping us make information about these technologies available to everyone. We
welcome more contributions from you.

