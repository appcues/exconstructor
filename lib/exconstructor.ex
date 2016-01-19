defmodule ExConstructor do
  @moduledoc ~s"""
  ExConstructor is an Elixir library which makes it easier to instantiate
  structs from external data, such as that emitted by a JSON parser.

  It provides a `define_constructor` macro that can be invoked from struct
  modules.  This macro defines a constructor, by default called `new`,
  that accepts struct values as either a map or a dict, whose keys are
  either strings, and whose keys may be formatted in `camelCase` or
  `under_score` format (or a literal match on the struct field name).

  ## Installation

  1. Add ExConstructor to your list of dependencies in `mix.exs`:

          def deps do
            [{:exconstructor, "~> #{ExConstructor.Mixfile.project[:version]}"}]
          end

  2. Ensure ExConstructor is started before your application:

          def application do
            [applications: [:exconstructor]]
          end

  ## Usage

  Example:

      iex(1)> defmodule TestStruct do
      ...(1)>   import ExConstructor
      ...(1)>   defstruct field_one: 1,
      ...(1)>             field_two: 2,
      ...(1)>             field_three: 3,
      ...(1)>             field_four: 4,
      ...(1)>             field_five: 5
      ...(1)>   define_constructor
      ...(1)> end
      iex(2)> TestStruct.new(%{"field_one" => "a", "fieldTwo" => "b", :field_three => "c", :fieldFour => "d"})
      %TestStruct{field_one: "a", field_two: "b", field_three: "c", field_four: "d", field_five: 5}

  ## Authorship and License

  ExConstructor is copyright 2016 Appcues, Inc.

  ExConstructor is released under the
  [MIT License](https://github.com/appcues/exsentry/blob/master/LICENSE.txt).
  """

  @doc ~S"""
  Defines a constructor for the struct defined in the module in which this
  macro was invoked.  This constructor accepts a map or dict of keys and values.
  Keys may be strings or atoms, in camelCase or under_score format.
  """
  defmacro define_constructor(function_name \\ :new) do
    quote do
      def unquote(function_name)(map_or_dict, opts \\ []) do
        default = %__MODULE__{}
        map = Map.new(map_or_dict)
        keys = default |> Map.from_struct |> Map.keys
        Enum.reduce keys, default, fn (atom, acc) ->
          str = to_string(k)
          under_str = Mix.Utils.underscore(str)
          camel_str = Mix.Utils.camelize(str) |> ExConstructor.Utils.lcfirst
          under_atom = String.to_atom(under_str)
          camel_atom = String.to_atom(camel_str)
          value = cond do
            Map.has_key?(map, str) -> Map.get(map, str)
            Map.has_key?(map, atom) -> Map.get(map, atom)
            Map.has_key?(map, under_str) -> Map.get(map, under_str)
            Map.has_key?(map, under_atom) -> Map.get(map, under_atom)
            Map.has_key?(map, camel_str) -> Map.get(map, camel_str)
            Map.has_key?(map, camel_atom) -> Map.get(map, camel_atom)
            true -> Map.get(default, atom)
          end
          Map.put(acc, atom, value)
        end
      end
    end
  end

  defmodule Utils do
    @doc ~s"""
    Returns a copy of `str` with the first character lowercased.

        iex> ExConstructor.Utils.lcfirst("OmgThisIsCool")
        "omgThisIsCool"
    """
    def lcfirst(str) do
      first = String.slice(str, 0..0) |> String.downcase
      first <> String.slice(str, 1..-1)
    end
  end
end

