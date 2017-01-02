<h2 id="generics">Generics</h2>

<h3><a href="#what-is-monomorphisation" name="what-is-monomorphisation">
What is "monomorphisation"?
</a></h3>

Monomorphisation specializes each use of a generic function (or structure) with specific instance,
based on the parameter types of calls to that function (or uses of the structure).

During monomorphisisation a new copy of the generic function is translated for each unique set of types the function is instantiated with. This is the same strategy used by C++. It results in fast code that is specialized for every call-site and statically dispatched, with the tradeoff that functions instantiated with many different types can cause "code bloat", where multiple function instances result in larger binaries than would be created with other translation strategies.

Functions that accept [trait objects](https://doc.rust-lang.org/book/trait-objects.html) instead of type parameters do not undergo monomorphisation. Instead, methods on the trait objects are dispatched dynamically at runtime.

<h3><a href="#whats-the-difference-between-a-function-and-a-closure-that-doesnt-capture" name="whats-the-difference-between-a-function-and-a-closure-that-doesnt-capture">
What's the difference between a function and a closure that doesn't capture any variables?
</a></h3>

Functions and closures are operationally equivalent, but have different runtime representations due to their differing implementations.

Functions are a built-in primitive of the language, while closures are essentially syntactic sugar for one of three traits: [`Fn`][Fn], [`FnMut`][FnMut], and [`FnOnce`][FnOnce]. When you make a closure, the Rust compiler automatically creates a struct implementing the appropriate trait of those three and containing the captured environment variables as members, and makes it so the struct can be called as a function. Bare functions can not capture an environment.

The big difference between these traits is how they take the `self` parameter. [`Fn`][Fn] takes `&self`, [`FnMut`][FnMut] takes `&mut self`, and [`FnOnce`][FnOnce] takes `self`.

Even if a closure does not capture any environment variables, it is represented at runtime as two pointers, the same as any other closure.

<h3><a href="#what-are-higher-kinded-types" name="what-are-higher-kinded-types">
What are higher-kinded types, why would I want them, and why doesn't Rust have them?
</a></h3>

Higher-kinded types are types with unfilled parameters. Type constructors, like [`Vec`][Vec], [`Result`][Result], and [`HashMap`][HashMap] are all examples of higher-kinded types: each requires some additional type parameters in order to actually denote a specific type, like `Vec<u32>`. Support for higher-kinded types means these "incomplete" types may be used anywhere "complete" types can be used, including as generics for functions.

Any complete type, like [`i32`][i32], [`bool`][bool], or [`char`][char] is of kind `*` (this notation comes from the field of type theory). A type with one parameter, like [`Vec<T>`][Vec] is of kind `* -> *`, meaning that [`Vec<T>`][Vec] takes in a complete type like [`i32`][i32] and returns a complete type `Vec<i32>`. A type with three parameters, like [`HashMap<K, V, S>`][HashMap] is of kind `* -> * -> * -> *`, and takes in three complete types (like [`i32`][i32], [`String`][String], and [`RandomState`][RandomState]) to produce a new complete type `HashMap<i32, String, RandomState>`.

In addition to these examples, type constructors can take *lifetime* arguments, which we'll denote as `Lt`. For example, `slice::Iter` has kind `Lt -> * -> *`, because it must be instantiated like `Iter<'a, u32>`.

The lack of support for higher-kinded types makes it difficult to write certain kinds of generic code. It's particularly problematic for abstracting over concepts like iterators, since iterators are often parameterized over a lifetime at least. That in turn has prevented the creation of traits abstracting over Rust's collections.

Another common example is concepts like functors or monads, both of which are type constructors, rather than single types.

Rust doesn't currently have support for higher-kinded types because it hasn't been a priority compared to other improvements we want to make. Since the design is a major, cross-cutting change, we also want to approach it carefully. But there's no inherent reason for the current lack of support.

<h3><a href="#what-do-named-type-parameters-in-generic-types-mean" name="what-do-named-type-parameters-in-generic-types-mean">
What do named type parameters like <code>&lt;T=Foo&gt;</code> in generic types mean?
</a></h3>

These are called [associated types](https://doc.rust-lang.org/stable/book/associated-types.html), and they allow for the expression of trait bounds that can't be expressed with a `where` clause. For example, a generic bound `X: Bar<T=Foo>` means "`X` must implement the trait `Bar`, and in that implementation of `Bar`, `X` must choose `Foo` for `Bar`'s associated type, `T`." Examples of where such a constraint cannot be expressed via a `where` clause include trait objects like `Box<Bar<T=Foo>>`.

Associated types exist because generics often involve families of types, where one type determines all of the others in a family. For example, a trait for graphs might have as its `Self` type the graph itself, and have associated types for nodes and for edges. Each graph type uniquely determines the associated types. Using associated types makes it much more concise to work with these families of types, and also provides better type inference in many cases.

<h3><a href="#how-do-i-overload-operators" name="how-do-i-overload-operators">
Can I overload operators? Which ones and how?
</a></h3>

You can provide custom implementations for a variety of operators using their associated traits: [`Add`][Add] for `+`, [`Mul`][Mul] for `*`, and so on. It looks like this:

```rust
use std::ops::Add;

struct Foo;

impl Add for Foo {
    type Output = Foo;
    fn add(self, rhs: Foo) -> Self::Output {
        println!("Adding!");
        self
    }
}
```

The following operators can be overloaded:

| Operation            | Trait                          |
|:---------------------|:-------------------------------|
| `+`                  | [`Add`][Add]                   |
| `+=`                 | [`AddAssign`][AddAssign]       |
| `binary -`           | [`Sub`][Sub]                   |
| `-=`                 | [`SubAssign`][SubAssign]       |
| `*`                  | [`Mul`][Mul]                   |
| `*=`                 | [`MulAssign`][MulAssign]       |
| `/`                  | [`Div`][Div]                   |
| `/=`                 | [`DivAssign`][DivAssign]       |
| `unary -`            | [`Neg`][Neg]                   |
| `%`                  | [`Rem`][Rem]                   |
| `%=`                 | [`RemAssign`][RemAssign]       |
| `&`                  | [`BitAnd`][BitAnd]             |
| <code>&#124;</code>  | [`BitOr`][BitOr]               |
| <code>&#124;</code>= | [`BitOrAssign`][BitOrAssign]   |
| `^`                  | [`BitXor`][BitXor]             |
| `^=`                 | [`BitXorAssign`][BitXorAssign] |
| `!`                  | [`Not`][Not]                   |
| `<<`                 | [`Shl`][Shl]                   |
| `<<=`                | [`ShlAssign`][ShlAssign]       |
| `>>`                 | [`Shr`][Shr]                   |
| `>>=`                | [`ShrAssign`][ShrAssign]       |
| `*`                  | [`Deref`][Deref]               |
| `mut *`              | [`DerefMut`][DerefMut]         |
| `[]`                 | [`Index`][Index]               |
| `mut []`             | [`IndexMut`][IndexMut]         |

<h3><a href="#why-the-split-between-eq-partialeq-and-ord-partialord" name="why-the-split-between-eq-partialeq-and-ord-partialord">
Why the split between <code>Eq</code>/<code>PartialEq</code> and <code>Ord</code>/<code>PartialOrd</code>?
</a></h3>

There are some types in Rust whose values are only partially ordered, or have only partial equality. Partial ordering means that there may be values of the given type that are neither less than nor greater than each other. Partial equality means that there may be values of the given type that are not equal to themselves.

Floating point types ([`f32`][f32] and [`f64`][f64]) are good examples of each. Any floating point type may have the value `NaN` (meaning "not a number"). `NaN` is not equal to itself (`NaN == NaN` is false), and not less than or greater than any other floating point value. As such, both [`f32`][f32] and [`f64`][f64] implement [`PartialOrd`][PartialOrd] and [`PartialEq`][PartialEq] but not [`Ord`][Ord] and not [`Eq`][Eq].

As explained in [the earlier question on floats](#why-cant-i-compare-floats), these distinctions are important because some collections rely on total orderings/equality in order to give correct results.

