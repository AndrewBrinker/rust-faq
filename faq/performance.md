<h2 id="performance">Performance</h2>

<h3><a href="#how-fast-is-rust" name="how-fast-is-rust">
How fast is Rust?
</a></h3>

Fast! Rust is already competitive with idiomatic C and C++ in a number of benchmarks (like the [Benchmarks Game](https://benchmarksgame.alioth.debian.org/u64q/compare.php?lang=rust&lang2=gpp) and [others](https://github.com/kostya/benchmarks)).

Like C++, Rust takes [zero-cost abstractions](http://blog.rust-lang.org/2015/05/11/traits.html) as one of its core principles: none of Rust's abstractions impose a global performance penalty, nor is there overhead from any runtime system.

Given that Rust is built on LLVM and strives to resemble Clang from LLVM's perspective, any LLVM performance improvements also help Rust. In the long run, the richer information in Rust's type system should also enable optimizations that are difficult or impossible for C/C++ code.

<h3><a href="#is-rust-garbage-collected" name="is-rust-garbage-collected">
Is Rust garbage collected?
</a></h3>

No. One of Rust's key innovations is guaranteeing memory safety (no segfaults) *without* requiring garbage collection.

By avoiding GC, Rust can offer numerous benefits: predictable cleanup of resources, lower overhead for memory management, and essentially no runtime system. All of these traits make Rust lean and easy to embed into arbitrary contexts, and make it much easier to [integrate Rust code with languages that have a GC](http://calculist.org/blog/2015/12/23/neon-node-rust/).

Rust avoids the need for GC through its system of ownership and borrowing, but that same system helps with a host of other problems, including
[resource management in general](http://blog.skylight.io/rust-means-never-having-to-close-a-socket/) and [concurrency](http://blog.rust-lang.org/2015/04/10/Fearless-Concurrency.html).

For when single ownership does not suffice, Rust programs rely on the standard reference-counting smart pointer type, [`Rc`](https://doc.rust-lang.org/std/rc/struct.Rc.html), and its thread-safe counterpart, [`Arc`](https://doc.rust-lang.org/std/sync/struct.Arc.html), instead of GC.

We are however investigating *optional* garbage collection as a future
extension. The goal is to enable smooth integration with
garbage-collected runtimes, such as those offered by the
[Spidermonkey](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey)
and [V8](https://developers.google.com/v8/?hl=en) JavaScript engines.
Finally, some people have investigated implementing
[pure Rust garbage collectors](https://manishearth.github.io/blog/2015/09/01/designing-a-gc-in-rust/)
without compiler support.

<h3><a href="#why-is-my-program-slow" name="why-is-my-program-slow">
Why is my program slow?
</a></h3>

The Rust compiler doesn't compile with optimizations unless asked to, [as optimizations slow down compilation and are usually undesirable during development](https://users.rust-lang.org/t/why-does-cargo-build-not-optimise-by-default/4150/3).

If you compile with `cargo`, use the `--release` flag. If you compile with `rustc` directly, use the `-O` flag. Either of these will turn on optimizations.

<h3><a href="#why-is-rustc-slow" name="why-is-rustc-slow">
Rust compilation seems slow. Why is that?
</a></h3>

Code translation and optimizations. Rust provides high level abstractions that compile down into efficient machine code, and those translations take time to run, especially when optimizing.

But Rust's compilation time is not as bad as it may seem, and there is reason to believe it will improve. When comparing projects of similar size between C++ and Rust, compilation time of the entire project is generally believed to be comparable. The common perception that Rust compilation is slow is in large part due to the differences in the *compilation model* between C++ and Rust: C++'s compilation unit is the file, while Rust's is the crate, composed of many files. Thus, during development, modifying a single C++ file can result in much less recompilation than in Rust. There is a major effort underway to refactor the compiler to introduce [incremental compilation](https://github.com/rust-lang/rfcs/blob/master/text/1298-incremental-compilation.md), which will provide Rust the compile time benefits of C++'s model.

Aside from the compilation model, there are several other aspects of Rust's language design and compiler implementation that affect compile-time performance.

First, Rust has a moderately-complex type system, and must spend a non-negligible amount of compile time enforcing the constraints that make Rust safe at runtime.

Secondly, the Rust compiler suffers from long-standing technical debt, and notably generates poor-quality LLVM IR which LLVM must spend time "fixing". There is hope that future [MIR-based](https://github.com/rust-lang/rfcs/blob/master/text/1211-mir.md) optimization and translation passes will ease the burden the Rust compiler places on LLVM.

Thirdly, Rust's use of LLVM for code generation is a double-edged sword: while it enables Rust to have world-class runtime performance, LLVM is a large framework that is not focused on compile-time performance, particularly when working with poor-quality inputs.

Finally, while Rust's preferred strategy of monomorphising generics (ala C++) produces fast code, it demands that significantly more code be generated than other translation strategies. Rust programmers can use trait objects to trade away this code bloat by using dynamic dispatch instead.

<h3><a href="#why-are-rusts-hashmaps-slow" name="why-are-rusts-hashmaps-slow">
Why are Rust's <code>HashMap</code>s slow?
</a></h3>

By default, Rust's [`HashMap`][HashMap] uses the [SipHash](https://131002.net/siphash/) hashing algorithm, which is designed to prevent [hash table collision attacks](http://programmingisterrible.com/post/40620375793/hash-table-denial-of-service-attacks-revisited) while providing [reasonable performance on a variety of workloads](https://www.reddit.com/r/rust/comments/3hw9zf/rust_hasher_comparisons/cub4oh6).

While SipHash [demonstrates competitive performance](http://cglab.ca/%7Eabeinges/blah/hash-rs/) in many cases, one case where it is notably slower than other hashing algorithms is with short keys, such as integers. This is why Rust programmers often observe slow performance with [`HashMap`][HashMap]. The [FNV hasher](https://crates.io/crates/fnv) is frequently recommended for these cases, but be aware that it does not have the same collision-resistance properties as SipHash.

<h3><a href="#why-is-there-no-integrated-benchmarking" name="why-is-there-no-integrated-benchmarking">
Why is there no integrated benchmarking infrastructure?
</a></h3>

There is, but it's only available on the nightly release channel. We ultimately plan to build a pluggable system for integrated benchmarks, but in the meantime, the current system is [considered unstable](https://github.com/rust-lang/rust/issues/29553).

<h3><a href="#does-rust-do-tail-call-optimization" name="does-rust-do-tail-call-optimization">
Does Rust do tail-call optimization?
</a></h3>

Not generally, no. Tail-call optimization may be done in [limited circumstances](http://llvm.org/docs/CodeGenerator.html#sibling-call-optimization), but is [not guaranteed](https://mail.mozilla.org/pipermail/rust-dev/2013-April/003557.html). As the feature has always been desired, Rust has a keyword (`become`) reserved, though it is not clear yet whether it is technically possible, nor whether it will be implemented. There was a [proposed extension](https://github.com/rust-lang/rfcs/pull/81) that would allow tail-call elimination in certain contexts, but it is currently postponed.

<h3><a href="#does-rust-have-a-runtime" name="does-rust-have-a-runtime">
Does Rust have a runtime?
</a></h3>

Not in the typical sense used by languages such as Java, but parts of the Rust standard library can be considered a "runtime", providing a heap, backtraces, unwinding, and stack guards. There is a [small amount of initialization code](https://github.com/rust-lang/rust/blob/33916307780495fe311fe9c080b330d266f35bfb/src/libstd/rt.rs#L43) that runs before the user's `main` function. The Rust standard library additionally links to the C standard library, which does similar [runtime initialization](http://www.embecosm.com/appnotes/ean9/html/ch05s02.html). Rust code can be compiled without the standard library, in which case the runtime is roughly equivalent to C's.

