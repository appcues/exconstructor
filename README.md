# ExConstructor

ExConstructor is an Elixir library which makes it easier to instantiate
structs from external data, such as that emitted by a JSON parser.

It provides a `define_constructor` macro that can be invoked from struct
modules.  This macro defines a constructor, by default called `new`,
that accepts struct values as either a map or a dict, whose keys are
either strings, and whose keys may be formatted in `camelCase` or
`under_score` format (or a literal match on the struct field name).

## Authorship and License

ExConstructor is copyright 2016 Appcues, Inc.

ExConstructor is released under the
[MIT License](https://github.com/appcues/exconstructor/blob/master/LICENSE.txt).

