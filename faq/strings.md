<h2 id="strings">Strings</h2>

<h3><a href="#how-to-convert-string-or-vec-to-slice" name="how-to-convert-string-or-vec-to-slice">
How can I convert a <code>String</code> or <code>Vec&lt;T&gt;</code> to a slice (<code>&amp;str</code> and <code>&amp;[T]</code>)?
</a></h3>

Usually, you can pass a reference to a `String` or `Vec<T>` wherever a slice is expected.
Using [Deref coercions](https://doc.rust-lang.org/stable/book/deref-coercions.html), [`String`s][String] and [`Vec`s][Vec] will automatically coerce to their respective slices when passed by reference with `&` or `& mut`.

Methods implemented on `&str` and `&[T]` can be accessed directly on `String` and `Vec<T>`. For example, `some_string.char_at(0)` will work even though `char_at` is a method on `&str` and `some_string` is a `String`.

In some cases, such as generic code, it's necessary to convert manually. Manual conversions can be achieved using the slicing operator, like so: `&my_vec[..]`.

<h3><a href="#how-to-convert-between-str-and-string" name="how-to-convert-between-str-and-string">
How can I convert from <code>&amp;str</code> to <code>String</code> or the other way around?
</a></h3>

The [`to_string()`][to_string] method converts from a [`&str`][str] into a [`String`][String], and [`String`s][String] are automatically converted into [`&str`][str] when you borrow a reference to them. Both are demonstrated in the following example:

```rust
fn main() {
    let s = "Jane Doe".to_string();
    say_hello(&s);
}

fn say_hello(name: &str) {
    println!("Hello {}!", name);
}
```

<h3><a href="#what-are-the-differences-between-str-and-string" name="what-are-the-differences-between-str-and-string">
What are the differences between the two different string types?
</a></h3>

[`String`][String] is an owned buffer of UTF-8 bytes allocated on the heap. Mutable [`String`s][String] can be modified, growing their capacity as needed. [`&str`][str] is a fixed-capacity "view" into a [`String`][String] allocated elsewhere, commonly on the heap, in the case of slices dereferenced from [`String`s][String], or in static memory, in the case of string literals.

[`&str`][str] is a primitive type implemented by the Rust language, while [`String`][String] is implemented in the standard library.

<h3><a href="#how-do-i-do-o1-character-access-in-a-string" name="how-do-i-do-o1-character-access-in-a-string">
How do I do O(1) character access in a <code>String</code>?
</a></h3>

You cannot. At least not without a firm understanding of what you mean by "character", and preprocessing the string to find the index of the desired character.

Rust strings are UTF-8 encoded. A single visual character in UTF-8 is not necessarily a single byte as it would be in an ASCII-encoded string. Each byte is called a "code unit" (in UTF-16, code units are 2 bytes; in UTF-32 they are 4 bytes). "Code points" are composed of one or more code units, and combine in "grapheme clusters" which most closely approximate characters.

Thus, even though you may index on bytes in a UTF-8 string, you can't access the `i`th code point or grapheme cluster in constant time. However, if you know at which byte that desired code point or grapheme cluster begins, then you _can_ access it in constant time. Functions including [`str::find()`][str__find] and regex matches return byte indices, facilitating this sort of access.

<h3><a href="#why-are-strings-utf-8" name="why-are-strings-utf-8">
Why are strings UTF-8 by default?
</a></h3>

The [`str`][str] type is UTF-8 because we observe more text in the wild in this encoding – particularly in network transmissions, which are endian-agnostic – and we think it's best that the default treatment of I/O not involve having to recode codepoints in each direction.

This does mean that locating a particular Unicode codepoint inside a string is an O(n) operation, although if the starting byte index is already known then they can be accessed in O(1) as expected. On the one hand, this is clearly undesirable; on the other hand, this problem is full of trade-offs and we'd like to point out a few important qualifications:

Scanning a [`str`][str] for ASCII-range codepoints can still be done safely byte-at-a-time. If you use [`.as_bytes()`][str__as_bytes], pulling out a [`u8`][u8] costs only `O(1)` and produces a value that can be cast and compared to an ASCII-range [`char`][char]. So if you're (say) line-breaking on `'\n'`, byte-based treatment still works. UTF-8 was well-designed this way.

Most "character oriented" operations on text only work under very restricted language assumptions such as "ASCII-range codepoints only". Outside ASCII-range, you tend to have to use a complex (non-constant-time) algorithm for determining linguistic-unit (glyph, word, paragraph) boundaries anyway. We recommend using an "honest" linguistically-aware, Unicode-approved algorithm.

The [`char`][char] type is UTF-32. If you are sure you need to do a codepoint-at-a-time algorithm, it's trivial to write a `type wstr = [char]`, and unpack a [`str`][str] into it in a single pass, then work with the `wstr`. In other words: the fact that the language is not "decoding to UTF32 by default" shouldn't stop you from decoding (or re-encoding any other way) if you need to work with that encoding.

For a more in-depth explanation of why UTF-8 is usually preferable over UTF-16 or UTF-32, read the [UTF-8 Everywhere manifesto](http://utf8everywhere.org/).

<h3><a href="#what-string-type-should-i-use" name="what-string-type-should-i-use">
What string type should I use?
</a></h3>

Rust has four pairs of string types, [each serving a distinct purpose](http://www.suspectsemantics.com/blog/2016/03/27/string-types-in-rust/). In each pair, there is an "owned" string type, and a "slice" string type. The organization looks like this:

|               | "Slice" type | "Owned" type |
|:--------------|:-------------|:-------------|
| UTF-8         | `str`        | `String`     |
| OS-compatible | `OsStr`      | `OsString`   |
| C-compatible  | `CStr`       | `CString`    |
| System path   | `Path`       | `PathBuf`    |

Rust's different string types serve different purposes. `String` and `str` are UTF-8 encoded general-purpose strings. `OsString` and `OsStr` are encoded according to the current platform, and are used when interacting with the operating system. `CString` and `CStr` are the Rust equivalent of strings in C, and are used in FFI code, and `PathBuf` and `Path` are convenience wrappers around `OsString` and `OsStr`, providing methods specific to path manipulation.

<h3><a href="#why-are-there-multiple-types-of-strings" name="why-are-there-multiple-types-of-strings">
How can I write a function that accepts both <code>&str</code> and <code>String</code>?
</a></h3>

There are several options, depending on the needs of the function:

- If the function needs an owned string, but wants to accept any type of string, use an `Into<String>` bound.
- If the function needs a string slice, but wants to accept any type of string, use an `AsRef<str>` bound.
- If the function does not care about the string type, and wants to handle the two possibilities uniformly, use `Cow<str>` as the input type.

__Using `Into<String>`__

In this example, the function will accept both owned strings and string slices, either doing nothing or converting the input into an owned string within the function body. Note that the conversion needs to be done explicitly, and will not happen otherwise.

```rust
fn accepts_both<S: Into<String>>(s: S) {
    let s = s.into();   // This will convert s into a `String`.
    // ... the rest of the function
}
```

__Using `AsRef<str>`__

In this example, the function will accept both owned strings and string slices, either doing nothing or converting the input into a string slice. This can be done automatically by taking the input by reference, like so:

```rust
fn accepts_both<S: AsRef<str>>(s: &S) {
    // ... the body of the function
}
```

__Using `Cow<str>`__

In this example, the function takes in a `Cow<str>`, which is not a generic type but a container, containing either an owned string or string slice as needed.

```rust
fn accepts_cow(s: Cow<str>) {
    // ... the body of the function
}
```

