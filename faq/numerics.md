<h2 id="numerics">Numerics</h2>

<h3><a href="#which-type-of-float-should-i-use" name="which-type-of-float-should-i-use">
Which of <code>f32</code> and <code>f64</code> should I prefer for floating-point math?
</a></h3>

The choice of which to use is dependent on the purpose of the program.

If you are interested in the greatest degree of precision with your floating point numbers, then prefer [`f64`][f64]. If you are more interested in keeping the size of the value small or being maximally efficient, and are not concerned about the associated inaccuracy of having fewer bits per value, then [`f32`][f32] is better. Operations on [`f32`][f32] are usually faster, even on 64-bit hardware. As a common example, graphics programming typically uses [`f32`][f32] because it requires high performance, and 32-bit floats are sufficient for representing pixels on the screen.

If in doubt, choose [`f64`][f64] for the greater precision.

<h3><a href="#why-cant-i-compare-floats" name="why-cant-i-compare-floats">
Why can't I compare floats or use them as <code>HashMap</code> or <code>BTreeMap</code> keys?
</a></h3>

Floats can be compared with the `==`, `!=`, `<`, `<=`, `>`, and `>=` operators, and with the `partial_cmp()` function. `==` and `!=` are part of the [`PartialEq`][PartialEq] trait, while `<`, `<=`, `>`, `>=`, and `partial_cmp()` are part of the [`PartialOrd`][PartialOrd] trait.

Floats cannot be compared with the `cmp()` function, which is part of the [`Ord`][Ord] trait, as there is no total ordering for floats. Furthermore, there is no total equality relation for floats, and so they also do not implement the [`Eq`][Eq] trait.

There is no total ordering or equality on floats because the floating-point value [`NaN`](https://en.wikipedia.org/wiki/NaN) is not less than, greater than, or equal to any other floating-point value or itself.

Because floats do not implement [`Eq`][Eq] or [`Ord`][Ord], they may not be used in types whose trait bounds require those traits, such as [`BTreeMap`][BTreeMap] or [`HashMap`][HashMap]. This is important because these types *assume* their keys provide a total ordering or total equality relation, and will malfunction otherwise.

There [is a crate](https://crates.io/crates/ordered-float) that wraps [`f32`][f32] and [`f64`][f64] to provide [`Ord`][Ord] and [`Eq`][Eq] implementations, which may be useful in certain cases.

<h3><a href="#how-can-i-convert-between-numeric-types" name="how-can-i-convert-between-numeric-types">
How can I convert between numeric types?
</a></h3>

There are two ways: the `as` keyword, which does simple casting for primitive types, and the [`Into`][Into] and [`From`][From] traits, which are implemented for a number of type conversions (and which you can implement for your own types). The [`Into`][Into] and [`From`][From] traits are only implemented in cases where conversions are lossless, so for example, `f64::from(0f32)` will compile while `f32::from(0f64)` will not. On the other hand, `as` will convert between any two primitive types, truncating values as necessary.


<h3><a href="#why-doesnt-rust-have-increment-and-decrement-operators" name="why-doesnt-rust-have-increment-and-decrement-operators">
Why doesn't Rust have increment and decrement operators?
</a></h3>

Preincrement and postincrement (and the decrement equivalents), while convenient, are also fairly complex. They require knowledge of evaluation order, and often lead to subtle bugs and undefined behavior in C and C++. `x = x + 1` or `x += 1` is only slightly longer, but unambiguous.

