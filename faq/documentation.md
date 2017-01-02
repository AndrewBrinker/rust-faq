<h2 id="documentation">Documentation</h2>

<h3><a href="#why-are-so-many-rust-answers-on-stackoverflow-wrong" name="why-are-so-many-rust-answers-on-stackoverflow-wrong">
Why are so many Rust answers on Stack Overflow wrong?
</a></h3>

The Rust language has been around for a number of years, and only reached version 1.0 in May of 2015. In the time before then the language changed significantly, and a number of Stack Overflow answers were given at the time of older versions of the language.

Over time more and more answers will be offered for the current version, thus improving this issue as the proportion of out-of-date answers is reduced.

<h3><a href="#where-do-i-report-issues-in-the-rust-documentation" name="where-do-i-report-issues-in-the-rust-documentation">
Where do I report issues in the Rust documentation?
</a></h3>

You can report issues in the Rust documentation on the Rust compiler [issue tracker](https://github.com/rust-lang/rust/issues). Make sure to read the [contributing guidelines](https://github.com/rust-lang/rust/blob/master/CONTRIBUTING.md#writing-documentation) first.

<h3><a href="#how-do-i-view-rustdoc-documentation-for-a-library-my-project-depends-on" name="how-do-i-view-rustdoc-documentation-for-a-library-my-project-depends-on">
How do I view rustdoc documentation for a library my project depends on?
</a></h3>

When you use `cargo doc` to generate documentation for your own project, it also generates docs for the active dependency versions. These are put into the `target/doc` directory of your project. Use `cargo doc --open` to open the docs after building them, or just open up `target/doc/index.html` yourself.

