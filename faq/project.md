<h2 id="project">The Rust Project</h2>

<h3><a href="#what-is-this-projects-goal" name="what-is-this-projects-goal">
What is this project's goal?
</a></h3>

To design and implement a safe, concurrent, practical systems language.

Rust exists because other languages at this level of abstraction and efficiency are unsatisfactory. In particular:

1. There is too little attention paid to safety.
2. They have poor concurrency support.
3. There is a lack of practical affordances.
4. They offer limited control over resources.

Rust exists as an alternative that provides both efficient code and a comfortable level of abstraction, while improving on all four of these points.

<h3><a href="#is-this-project-controlled-by-mozilla" name="is-this-project-controlled-by-mozilla">
Is this project controlled by Mozilla?
</a></h3>

No. Rust started as Graydon Hoare's part-time side project in 2006 and remained so for over 3 years. Mozilla got involved in 2009 once the language was mature enough to run basic tests and demonstrate its core concepts. Though it remains sponsored by Mozilla, Rust is developed by a diverse community of enthusiasts from many different places around the world. The [Rust Team](https://www.rust-lang.org/team.html) is composed of both Mozilla and non-Mozilla members, and `rust` on GitHub has had over [1,500 unique contributors](https://github.com/rust-lang/rust/) so far.

As far as [project governance](https://github.com/rust-lang/rfcs/blob/master/text/1068-rust-governance.md) goes, Rust is managed by a core team that sets the vision and priorities for the project,
guiding it from a global perspective. There are also subteams to guide and foster development of particular areas of interest, including the core language, the compiler, Rust libraries, Rust tools, and moderation of the official Rust communities. Designs in each these areas are advanced through an [RFC process](https://github.com/rust-lang/rfcs). For changes which do not require an RFC, decisions are made through pull requests on the [`rustc` repository](https://github.com/rust-lang/rust).

<h3><a href="#what-are-some-non-goals" name="what-are-some-non-goals">
What are some non-goals of Rust?
</a></h3>

1. We do not employ any particularly cutting-edge technologies. Old, established techniques are better.
2. We do not prize expressiveness, minimalism or elegance above other goals. These are desirable but subordinate goals.
3. We do not intend to cover the complete feature-set of C++, or any other language. Rust should provide majority-case features.
4. We do not intend to be 100% static, 100% safe, 100% reflective, or too dogmatic in any other sense. Trade-offs exist.
5. We do not demand that Rust run on "every possible platform". It must eventually work without unnecessary compromises on widely-used hardware and software platforms.

<h3><a href="#how-does-mozilla-use-rust" name="how-does-mozilla-use-rust">
In which projects is Mozilla using Rust?
</a></h3>

The main project is [Servo](https://github.com/servo/servo), an experimental browser engine Mozilla is working on. They are also working to [integrate Rust components](https://bugzilla.mozilla.org/show_bug.cgi?id=1135640) into Firefox.

<h3><a href="#what-examples-are-there-of-large-rust-projects" name="what-examples-are-there-of-large-rust-projects">
What examples are there of large Rust projects?
</a></h3>

The two biggest open source Rust projects right now are [Servo](https://github.com/servo/servo) and the [Rust compiler](https://github.com/rust-lang/rust) itself.

<h3><a href="#who-else-is-using-rust" name="who-else-is-using-rust">
Who else is using Rust?
</a></h3>

[A growing number of organizations!](friends.html)

<h3><a href="#how-can-i-try-rust-easily" name="how-can-i-try-rust-easily">
How can I try Rust easily?
</a></h3>

The easiest way to try Rust is through the [playpen](https://play.rust-lang.org/), an online app for writing and running Rust code. If you want to try Rust on your system, [install it](https://www.rust-lang.org/install.html) and go through the [Guessing Game](https://doc.rust-lang.org/stable/book/guessing-game.html) tutorial in the book.

<h3><a href="#how-do-i-get-help-with-rust-issues" name="how-do-i-get-help-with-rust-issues">
How do I get help with Rust issues?
</a></h3>

There are several ways. You can:

- Post in [users.rust-lang.org](https://users.rust-lang.org/), the official Rust users forum
- Ask in the official [Rust IRC channel](https://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust) (#rust on irc.mozilla.org)
- Ask on [Stack Overflow](https://stackoverflow.com/questions/tagged/rust) with the "rust" tag
- Post in [/r/rust](https://www.reddit.com/r/rust), the unofficial Rust subreddit

<h3><a href="#why-has-rust-changed-so-much" name="why-has-rust-changed-so-much">
Why has Rust changed so much over time?
</a></h3>

Rust started with a goal of creating a safe but usable systems programming language. In pursuit of this goal it explored a lot of ideas, some of which it kept (lifetimes, traits) while others were discarded (the typestate system, green threading). Also, in the run up to 1.0 a lot of the standard library was rewritten as early designs were updated to best use Rust's features and provide quality, consistent cross-platform APIs. Now that Rust has reached 1.0, the language is guaranteed to be "stable"; and while it may continue to evolve, code which works on current Rust should continue to work on future releases.

<h3><a href="#how-does-rust-language-versioning-work" name="how-does-rust-language-versioning-work">
How does Rust language versioning work?
</a></h3>

Rust's language versioning follows [SemVer](http://semver.org/), with backwards incompatible changes of stable APIs only allowed in minor versions if those changes fix compiler bugs, patch safety holes, or change dispatch or type inference to require additional annotation. More detailed guidelines for minor version changes are available as approved RFCs for both the [language](https://github.com/rust-lang/rfcs/blob/master/text/1122-language-semver.md) and [standard library](https://github.com/rust-lang/rfcs/blob/master/text/1105-api-evolution.md).

Rust maintains three "release channels": stable, beta, and nightly. Stable and beta are updated every six weeks, with the current nightly becoming the new beta, and the current beta becoming the new stable. Language and standard library features marked unstable or hidden behind feature gates may only be used on the nightly release channel. New features land as unstable, and are "ungated" once approved by the core team and relevant subteams. This approach allows for experimentation while providing strong backwards-compatibility guarantees for the stable channel.

For additional details, read the Rust blog post ["Stability as a Deliverable."](http://blog.rust-lang.org/2014/10/30/Stability.html)

<h3><a href="#can-i-use-unstable-features-on-the-beta-or-stable-channel" name="can-i-use-unstable-features-on-the-beta-or-stable-channel">
Can I use unstable features on the beta or stable channel?
</a></h3>

No, you cannot. Rust works hard to provide strong guarantees about the stability of the features provided on the beta and stable channels. When something is unstable, it means that we can't provide those guarantees for it yet, and don't want people relying on it staying the same. This gives us the opportunity to try changes in the wild on the nightly release channel, while still maintaining strong guarantees for people seeking stability.

Things stabilize all the time, and the beta and stable channels update every six weeks, with occasional fixes accepted into beta at other times. If you're waiting for a feature to be available without using the nightly release channel, you can locate its tracking issue by checking the [`B-unstable`](https://github.com/rust-lang/rust/issues?q=is%3Aissue+is%3Aopen+tracking+label%3AB-unstable) tag on the issue tracker.

<h3><a href="#what-are-feature-gates" name="what-are-feature-gates">
What are "Feature Gates"?
</a></h3>

"Feature gates" are the mechanism Rust uses to stabilize features of the compiler, language, and standard library. A feature that is "gated" is accessible only on the nightly release channel, and then only when it has been explicitly enabled through `#[feature]` attributes or the `-Z unstable-options` command line argument. When a feature is stabilized it becomes available on the stable release channel, and does not need to be explicitly enabled. At that point the features is considered "ungated". Feature gates allow developers to test experimental features while they are under development, before they are available in the stable language.

<h3><a href="#why-a-dual-mit-asl2-license" name="why-a-dual-mit-asl2-license">
Why a dual MIT/ASL2 License?
</a></h3>

The Apache license includes important protection against patent aggression, but it is not compatible with the GPL, version 2. To avoid problems using Rust with GPL2, it is alternately MIT licensed.

<h3><a href="#why-a-permissive-license" name="why-a-permissive-license">
Why a BSD-style permissive license rather than MPL or tri-license?
</a></h3>

This is partly due to preference of the original developer (Graydon), and partly due to the fact that languages tend to have a wider audience and more diverse set of possible embeddings and end-uses than products such as web browsers. We'd like to appeal to as many of those potential contributors as possible.

