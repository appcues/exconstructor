# ExConstructor

[![Build Status](https://circleci.com/gh/appcues/exconstructor.svg?style=svg)](https://circleci.com/gh/appcues/exconstructor)
[![Coverage Status](https://coveralls.io/repos/github/appcues/exconstructor/badge.svg?branch=master)](https://coveralls.io/github/appcues/exconstructor?branch=master)
[![Module Version](https://img.shields.io/hexpm/v/exconstructor.svg)](https://hex.pm/packages/exconstructor)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/exconstructor/)
[![Total Download](https://img.shields.io/hexpm/dt/exconstructor.svg)](https://hex.pm/packages/exconstructor)
[![License](https://img.shields.io/hexpm/l/exconstructor.svg)](https://github.com/appcues/exconstructor/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/appcues/exconstructor.svg)](https://github.com/appcues/exconstructor/commits/master)

<!-- MDOC !-->

ExConstructor is an Elixir library that makes it easy to instantiate
structs from external data, such as that emitted by a JSON parser.

Add `use ExConstructor` after a `defstruct` statement to inject
a constructor function into the module.

The generated constructor, called `new` by default,
handles *map-vs-keyword-list*, *string-vs-atom-keys*, and
*camelCase-vs-under_score* input data issues automatically,
DRYing up your code and letting you move on to the interesting
parts of your program.

## Installation

Add `:exconstructor` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exconstructor, "~> 1.2"}
  ]
end
```

## Example

```elixir
defmodule TestStruct do
  defstruct field_one: nil,
            field_two: nil,
            field_three: nil,
            field_four: nil
  use ExConstructor
end

TestStruct.new(%{"field_one" => "a", "fieldTwo" => "b", :field_three => "c", :FieldFour => "d"})
# => %TestStruct{field_one: "a", field_two: "b", field_three: "c", field_four: "d"}
```

For advanced usage, see `ExConstructor.__using__/1` and `ExConstructor.populate_struct/3`.

<!-- MDOC !-->

## Contributors

Many thanks to those who've contributed to ExConstructor:

* Graeme Coupar ([@grambo](https://github.com/grambo))
* Mel Kicchi ([@meowy](https://github.com/meowy))
* Andrey Ronin ([@anronin](https://github.com/anronin))


## How to Contribute

My favorite contributions are PRs with code that matches project style,
and that come with full test coverage and documentation.  I have a hard
time saying no to them.

Feature requests are also welcome, but the timeline may be much longer.

Bug reports are great -- please include as much information as possible
(Erlang/Elixir/Mix version, dependencies and their versions, minimal
test case, etc.) and I will be much quicker in resolving the issue.


## Copyright and License

Copyright (c) 2016 Appcues, Inc.

ExConstructor is released under the
[MIT License](https://github.com/appcues/exconstructor/blob/master/LICENSE.txt).
