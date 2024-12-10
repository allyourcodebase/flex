# FLex

[![CI][ci-shd]][ci-url]
[![License][lc-shd]][lc-url]

## Zig build for [FLex](https://github.com/westes/flex).

Uses the generated c code from the [flex release tarball][flex-release].

Does not try to build flex from source, [as building flex requires flex][issue-458].

If you want to build flex from source, the following resources may be helpful:

- https://bootstrapping.miraheze.org/wiki/Live-bootstrap#flex_2.5.11
- https://github.com/fosslinux/live-bootstrap/tree/master/steps/flex-2.5.11
- https://en.wikipedia.org/wiki/Flex_(lexical_analyser_generator)
- https://tomassetti.me/why-you-should-not-use-flex-yacc-and-bison/
- https://pubs.opengroup.org/onlinepubs/9799919799/utilities/lex.html
- https://pubs.opengroup.org/onlinepubs/9799919799/utilities/yacc.html

### Usage

```sh
git clone https://github.com/allyourcodebase/flex.git
cd flex/
zig build
```

### License

- [This build script is licensed under a BSD 2-Clause license][lc-url]
- [flex itself is licensed under a modified BSD 2-Clause license][flex-copying]

<!-- MARKDOWN LINKS -->

[flex-release]: https://github.com/westes/flex/releases/tag/v2.6.4
[issue-458]: https://github.com/westes/flex/issues/458
[flex-copying]: https://github.com/westes/flex/blob/v2.6.4/COPYING

[ci-shd]: https://img.shields.io/github/actions/workflow/status/allyourcodebase/flex/ci.yaml?branch=main&style=for-the-badge&logo=github&label=CI&labelColor=black
[ci-url]: https://github.com/allyourcodebase/flex/blob/main/.github/workflows/ci.yaml
[lc-shd]: https://img.shields.io/github/license/allyourcodebase/flex.svg?style=for-the-badge&labelColor=black
[lc-url]: https://github.com/allyourcodebase/flex/blob/main/LICENSE.md
