# ExConstructor

[![wercker status](https://app.wercker.com/status/f2dbf92012667da4ac8511f619da4429/s/master "wercker status")](https://app.wercker.com/project/bykey/f2dbf92012667da4ac8511f619da4429)
[![Hex.pm Version](http://img.shields.io/hexpm/v/exconstructor.svg?style=flat)](https://hex.pm/packages/exconstructor)
[![Coverage Status](https://coveralls.io/repos/github/appcues/exconstructor/badge.svg?branch=master)](https://coveralls.io/github/appcues/exconstructor?branch=master)

ExConstructor is an Elixir library which makes it easier to instantiate
structs from external data, such as that emitted by a JSON parser.

It provides a `define_constructor` macro that can be invoked from struct
modules.  This macro defines a constructor, by default called `new`,
that accepts struct values as either a map or a dict, whose keys are
either strings, and whose keys may be formatted in `camelCase` or
`under_score` format (or a literal match on the struct field name).


## [Full Documentation](http://hexdocs.pm/exconstructor/ExConstructor.html)

[Full ExConstructor documentation is available on
Hexdocs.pm.](http://hexdocs.pm/exconstructor/ExConstructor.html)


## Authorship and License

ExConstructor is copyright 2016 Appcues, Inc.

ExConstructor is released under the
[MIT License](https://github.com/appcues/exconstructor/blob/master/LICENSE.txt).

