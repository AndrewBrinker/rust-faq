<h2 id="input-output">Input / Output</h2>

<h3><a href="#how-do-i-read-a-file-into-a-string" name="how-do-i-read-a-file-into-a-string">
How do I read a file into a <code>String</code>?
</a></h3>

Using the [`read_to_string()`][read__read_to_string] method, which is defined on the [`Read`][Read] trait in [`std::io`][std-io].

```rust
use std::io::Read;
use std::fs::File;

fn read_file(path: &str) -> Result<String, std::io::Error> {
    let mut f = try!(File::open(path));
    let mut s = String::new();
    try!(f.read_to_string(&mut s));  // `s` contains the contents of "foo.txt"
    Ok(s)
}

fn main() {
    match read_file("foo.txt") {
        Ok(_) => println!("Got file contents!"),
        Err(err) => println!("Getting file contents failed with error: {}", err)
    };
}
```

<h3><a href="#how-do-i-read-file-input-efficiently" name="how-do-i-read-file-input-efficiently">
How do I read file input efficiently?
</a></h3>

The [`File`][File] type implements the [`Read`][Read] trait, which has a variety of functions for reading and writing data, including [`read()`][read__read], [`read_to_end()`][read__read_to_end], [`bytes()`][read__bytes], [`chars()`][read__chars], and [`take()`][read__take]. Each of these functions reads a certain amount of input from a given file. [`read()`][read__read] reads as much input as the underlying system will provide in a single call. [`read_to_end()`][read__read_to_end] reads the entire buffer into a vector, allocating as much space as is needed. [`bytes()`][read__bytes] and [`chars()`][read__chars] allow you to iterate over the bytes and characters of the file, respectively. Finally, [`take()`][read__take] allows you to read up to an arbitrary number of bytes from the file. Collectively, these should allow you to efficiently read in any data you need.

For buffered reads, use the [`BufReader`][BufReader] struct, which helps to reduce the number of system calls when reading.

<h3><a href="#how-do-i-do-asynchronous-input-output-in-rust" name="how-do-i-do-asynchronous-input-output-in-rust">
How do I do asynchronous input / output in Rust?
</a></h3>

There are several libraries providing asynchronous input / output in Rust, including [mioco](https://github.com/dpc/mioco), [coio-rs](https://github.com/zonyitoo/coio-rs), and [rotor](https://github.com/tailhook/rotor).

<h3><a href="#how-do-i-get-command-line-arguments" name="how-do-i-get-command-line-arguments">
How do I get command line arguments in Rust?
</a></h3>

The easiest way is to use [`Args`][Args], which provides an iterator over the input arguments.

If you're looking for something more powerful, there are a [number of options on crates.io](https://crates.io/keywords/argument).

