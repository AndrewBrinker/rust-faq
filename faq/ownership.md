<h2 id="ownership">Ownership</h2>

<h3><a href="#how-can-i-implement-a-data-structure-that-contains-cycles" name="how-can-i-implement-a-data-structure-that-contains-cycles">
How can I implement a graph or other data structure that contains cycles?
</a></h3>

There are at least four options (discussed at length in [Too Many Linked Lists](http://cglab.ca/~abeinges/blah/too-many-lists/book/)):

- You can implement it using [`Rc`][Rc] and [`Weak`][Weak] to allow shared ownership of nodes,
although this approach pays the cost of memory management.
- You can implement it using `unsafe` code using raw pointers. This will be
more efficient, but bypasses Rust's safety guarantees.
- Using vectors and indices into those vectors. There are [several](http://smallcultfollowing.com/babysteps/blog/2015/04/06/modeling-graphs-in-rust-using-vector-indices/) [available](https://featherweightmusings.blogspot.com/2015/04/graphs-in-rust.html) examples and explanations of this approach.
- Using borrowed references with [`UnsafeCell`][UnsafeCell]. There are [explanations and code](https://github.com/nrc/r4cppp/blob/master/graphs/README.md#node-and-unsafecell) available for this approach.

<h3><a href="#how-can-i-define-a-struct-that-contains-a-reference-to-one-of-its-own-fields" name="how-can-i-define-a-struct-that-contains-a-reference-to-one-of-its-own-fields">
How can I define a struct that contains a reference to one of its own fields?
</a></h3>

It's possible, but useless to do so. The struct becomes permanently borrowed by itself and therefore can't be moved. Here is some code illustrating this:

```rust
use std::cell::Cell;

#[derive(Debug)]
struct Unmovable<'a> {
    x: u32,
    y: Cell<Option<&'a u32>>,
}


fn main() {
    let test = Unmovable { x: 42, y: Cell::new(None) };
    test.y.set(Some(&test.x));

    println!("{:?}", test);
}
```

<h3><a href="#what-is-the-difference-between-consuming-and-moving" name="what-is-the-difference-between-consuming-and-moving">
What is the difference between passing by value, consuming, moving, and transferring ownership?
</a></h3>

These are different terms for the same thing. In all cases, it means the value has been moved to another owner, and moved out of the possession of the original owner, who can no longer use it. If a type implements the `Copy` trait, the original owner's value won't be invalidated, and can still be used.

<h3><a href="#why-can-values-of-some-types-by-reused-while-others-are-consumed" name="why-can-values-of-some-types-by-reused-while-others-are-consumed">
Why can values of some types be used after passing them to a function, while reuse of values of other types results in an error?
</a></h3>

If a type implements the [`Copy`][Copy] trait, then it will be copied when passed to a function. All numeric types in Rust implement [`Copy`][Copy], but struct types do not implement [`Copy`][Copy] by default, so they are moved instead. This means that the struct can no longer be used elsewhere, unless it is moved back out of the function via the return.

<h3><a href="#how-do-you-deal-with-a-use-of-moved-value-error" name="how-do-you-deal-with-a-use-of-moved-value-error">
How do you deal with a "use of moved value" error?
</a></h3>

This error means that the value you're trying to use has been moved to a new owner. The first thing to check is whether the move in question was necessary: if it moved into a function, it may be possible to rewrite the function to use a reference, rather than moving. Otherwise if the type being moved implements [`Clone`][Clone], then calling `clone()` on it before moving will move a copy of it, leaving the original still available for further use. Note though that cloning a value should typically be the last resort since cloning can be expensive, causing further allocations.

If the moved value is of your own custom type, consider implementing [`Copy`][Copy] (for implicit copying, rather than moving) or [`Clone`][Clone] (explicit copying). [`Copy`][Copy] is most commonly implemented with `#[derive(Copy, Clone)]` ([`Copy`][Copy] requires [`Clone`][Clone]), and [`Clone`][Clone] with `#[derive(Clone)]`.

If none of these are possible, you may want to modify the function that acquired ownership to return ownership of the value when the function exits.

<h3><a href="#what-are-the-rules-for-different-self-types-in-methods" name="what-are-the-rules-for-different-self-types-in-methods">
What are the rules for using <code>self</code>, <code>&amp;self</code>, or <code>&amp;mut self</code> in a method declaration?
</a></h3>

- Use `self` when a function needs to consume the value
- Use `&self` when a function only needs a read-only reference to the value
- Use `&mut self` when a function needs to mutate the value without consuming it

<h3><a href="#how-can-i-understand-the-borrow-checker" name="how-can-i-understand-the-borrow-checker">
How can I understand the borrow checker?
</a></h3>

The borrow checker applies only a few rules, which can be found in the Rust book's [section on borrowing](https://doc.rust-lang.org/stable/book/references-and-borrowing.html#the-rules), when evaluating Rust code. These rules are:

> First, any borrow must last for a scope no greater than that of the owner. Second, you may have one or the other of these two kinds of borrows, but not both at the same time:
>
> - one or more references (&T) to a resource.
> - exactly one mutable reference (&mut T)

While the rules themselves are simple, following them consistently is not, particularly for those unaccustomed to reasoning about lifetimes and ownership.

The first step in understanding the borrow checker is reading the errors it produces. A lot of work has been put into making sure the borrow checker provides quality assistance in resolving the issues it identifies. When you encounter a borrow checker problem, the first step is to slowly and carefully read the error reported, and to only approach the code after you understand the error being described.

The second step is to become familiar with the ownership and mutability-related container types provided by the Rust standard library, including [`Cell`][Cell], [`RefCell`][RefCell], and [`Cow`][Cow]. These are useful and necessary tools for expressing certain ownership and mutability situations, and have been written to be of minimal performance cost.

The single most important part of understanding the borrow checker is practice. Rust's strong static analyses guarantees are strict and quite different from what many programmers have worked with before. It will take some time to become completely comfortable with everything.

If you find yourself struggling with the borrow checker, or running out of patience, always feel free to reach out to the [Rust community](community.html) for help.

<h3><a href="#when-is-rc-useful" name="when-is-rc-useful">
When is <code>Rc</code> useful?
</a></h3>

This is covered in the official documentation for [`Rc`][Rc], Rust's non-atomically reference-counted pointer type. In short, [`Rc`][Rc] and its thread-safe cousin [`Arc`][Arc] are useful to express shared ownership, and have the system automatically deallocate the associated memory when no one has access to it.

<h3><a href="#how-do-i-return-a-closure-from-a-function" name="how-do-i-return-a-closure-from-a-function">
How do I return a closure from a function?
</a></h3>

To return a closure from a function, it must be a "move closure", meaning that the closure is declared with the `move` keyword. As [explained in the Rust book](https://doc.rust-lang.org/book/closures.html#move-closures), this gives the closure its own copy of the captured variables, independent of its parent stack frame. Otherwise, returning a closure would be unsafe, as it would allow access to variables that are no longer valid; put another way: it would allow reading potentially invalid memory. The closure must also be wrapped in a [`Box`][Box], so that it is allocated on the heap. Read more about this [in the book](https://doc.rust-lang.org/book/closures.html#returning-closures).

<h3><a href="#what-are-deref-coercions" name="what-are-deref-coercions">
What is a deref coercion and how does it work?
</a></h3>

A [deref coercion](https://doc.rust-lang.org/book/deref-coercions.html) is a handy coercion
that automatically converts references to pointers (e.g., `&Rc<T>` or `&Box<T>`) into references
to their contents (e.g., `&T`). Deref coercions exist to make using Rust more ergonomic, and are implemented via the [`Deref`][Deref] trait.

A Deref implementation indicates that the implementing type may be converted into a target by a call to the `deref` method, which takes an immutable reference to the calling type and returns a reference (of the same lifetime) to the target type. The `*` prefix operator is shorthand for the `deref` method.

They're called "coercions" because of the following rule, quoted here [from the Rust book](https://doc.rust-lang.org/stable/book/deref-coercions.html):

> If you have a type `U`, and it implements `Deref<Target=T>`, values of `&U` will automatically coerce to a `&T`.

For example, if you have a `&Rc<String>`, it will coerce via this rule into a `&String`, which then coerces to a `&str` in the same way. So if a function takes a `&str` parameter, you can pass in a `&Rc<String>` directly, with all coercions handled automatically via the `Deref` trait.

The most common sorts of deref coercions are:

- `&Rc<T>` to `&T`
- `&Box<T>` to `&T`
- `&Arc<T>` to `&T`
- `&Vec<T>` to `&[T]`
- `&String` to `&str`

