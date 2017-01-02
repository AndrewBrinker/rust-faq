<h2 id="syntax">Syntax</h2>

<h3><a href="#why-curly-braces" name="why-curly-braces">
Why curly braces? Why can't Rust's syntax be like Haskell's or Python's?
</a></h3>

Use of curly braces to denote blocks is a common design choice in a variety of programming languages, and Rust's consistency is useful for people already familiar with the style.

Curly braces also allow for more flexible syntax for the programmer and a simpler parser in the compiler.

<h3><a href="#why-brackets-around-blocks" name="why-brackets-around-blocks">
I can leave out parentheses on <code>if</code> conditions, so why do I have to put brackets around single line blocks? Why is the C style not allowed?
</a></h3>

Whereas C requires mandatory parentheses for `if`-statement conditionals but leaves brackets optional, Rust makes the opposite choice for its `if`-expressions. This keeps the conditional clearly separate from the body and avoids the hazard of optional brackets, which can lead to easy-to-miss errors during refactoring, like Apple's [goto fail](https://gotofail.com/) bug.

<h3><a href="#why-no-literal-syntax-for-dictionaries" name="why-no-literal-syntax-for-dictionaries">
Why is there no literal syntax for dictionaries?
</a></h3>

Rust's overall design preference is for limiting the size of the *language* while enabling powerful *libraries*. While Rust does provide initialization syntax for arrays and string literals, these are the only collection types built into the language. Other library-defined types, including the ubiquitous [`Vec`][Vec] collection type, use macros for initialization like the [`vec!`][VecMacro] macro.

This design choice of using Rust's macro facilities to initialize collections will likely be extended generically to other collections in the future, enabling simple initialization of not only [`HashMap`][HashMap] and [`Vec`][Vec], but also other collection types such as [`BTreeMap`][BTreeMap]. In the meantime, if you want a more convenient syntax for initializing collections, you can [create your own macro](https://stackoverflow.com/questions/27582739/how-do-i-create-a-hashmap-literal) to provide it.

<h3><a href="#when-should-i-use-an-implicit-return" name="when-should-i-use-an-implicit-return">
When should I use an implicit return?
</a></h3>

Rust is a very expression-oriented language, and "implicit returns" are part of that design. Constructs like `if`s, `match`es, and normal blocks are all expressions in Rust. For example, the following code checks if an [`i64`][i64] is odd, returning the result by simply yielding it as a value:

```rust
fn is_odd(x: i64) -> bool {
    if x % 2 != 0 { true } else { false }
}
```

Although it can be simplified even further like so:

```rust
fn is_odd(x: i64) -> bool {
    x % 2 != 0
}
```

In each example, the last line of the function is the return value of that function. It is important to note that if a function ends in a semicolon, its return type will be `()`, indicating no returned value. Implicit returns must omit the semicolon to work.

Explicit returns are only used if an implicit return is impossible because you are returning before the end of the function's body. While each of the above functions could have been written with a `return` keyword and semicolon, doing so would be unnecessarily verbose, and inconsistent with the conventions of Rust code.

<h3><a href="#why-arent-function-signatures-inferred" name="why-arent-function-signatures-inferred">
Why aren't function signatures inferred?
</a></h3>

In Rust, declarations tend to come with explicit types, while actual code has its types inferred. There are several reasons for this design:

- Mandatory declaration signatures help enforce interface stability at both the module and crate level.
- Signatures improve code comprehension for the programmer, eliminating the need for an IDE running an inference algorithm across an entire crate to be able to guess at a function's argument types; it's always explicit and nearby.
- Mechanically, it simplifies the inference algorithm, as inference only requires looking at one function at a time.

<h3><a href="#why-does-match-have-to-be-exhaustive" name="why-does-match-have-to-be-exhaustive">
Why does <code>match</code> have to be exhaustive?
</a></h3>

To aid in refactoring and clarity.

First, if every possibility is covered by the `match`, adding variants to the `enum` in the future will cause a compilation failure, rather than an error at runtime. This type of compiler assistance makes fearless refactoring possible in Rust.

Second, exhaustive checking makes the semantics of the default case explicit: in general, the only safe way to have a non-exhaustive `match` would be to panic the thread if nothing is matched. Early versions of Rust did not require `match` cases to be exhaustive and it was found to be a great source of bugs.

It is easy to ignore all unspecified cases by using the `_` wildcard:

```rust
match val.do_something() {
    Cat(a) => { /* ... */ }
    _      => { /* ... */ }
}
```

