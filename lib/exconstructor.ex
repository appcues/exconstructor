defmodule ExConstructor do
  @moduledoc ~s"""
  ExConstructor is an Elixir library which makes it easier to instantiate
  structs from external data, such as that emitted by a JSON parser.

  Simply call `use ExConstructor` after a `defstruct` statement to inject
  a constructor function into the module.
  The generated constructor, called `new` by default,
  handles map-vs-keyword-list, string-vs-atom, and camelCase-vs-under_score
  input data issues automatically, DRYing up your code and letting you
  move on to the interesting parts of your program.

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

      defmodule TestStruct do
        defstruct field_one: 1,
                  field_two: 2,
                  field_three: 3,
                  field_four: 4,
        use ExConstructor
      end

      TestStruct.new(%{"field_one" => "a", "fieldTwo" => "b", :field_three => "c", :fieldFour => "d"})
      # => %TestStruct{field_one: "a", field_two: "b", field_three: "c", field_four: "d"}

  ## Authorship and License

  ExConstructor is copyright 2016 Appcues, Inc.

  ExConstructor is released under the
  [MIT License](https://github.com/appcues/exconstructor/blob/master/LICENSE.txt).
  """


  defmodule Options do
    @moduledoc ~S"""
    Represents the options passed to `populate_struct/3`.
    Set any value to `false` to disable checking for that kind of key.
    """
    defstruct strings: true,
              atoms: true,
              camelcase: true,
              underscore: true
  end


  @doc ~S"""
  Defines a constructor for the struct defined in the module in which this
  macro was invoked.  This constructor accepts a map or keyword list of
  keys and values, as well as an optional `opts` keyword list (currently
  ignored).
  Keys may be strings or atoms, in camelCase or under_score format.
  """
  defmacro __using__(constructor_name_or_opts \\ :new) do
    opts = cond do
             is_atom(constructor_name_or_opts) -> [name: constructor_name_or_opts]
             is_list(constructor_name_or_opts) -> constructor_name_or_opts
             true -> raise "argument must be atom (constructor name) or keyword list (opts)"
           end
    constructor_name = opts[:name] || :new

    quote do
      def unquote(constructor_name)(map_or_kwlist, opts \\ []) do
        ExConstructor.populate_struct(
          %__MODULE__{},
          map_or_kwlist,
          Dict.merge(unquote(opts), opts)
        )
      end
    end
  end

  defmacro define_constructor(constructor_name_or_opts \\ :new) do
    quote do
      ExConstructor.__using__(unquote(constructor_name_or_opts))
    end
  end

  @doc ~S"""
  Returns a copy of `struct` into which the values in `map_or_kwlist`
  have been applied.  `opts` determines whether to allow string keys,
  atom keys, camelcase keys, or underscore keys; all default to `true`.
  """
  def populate_struct(struct, map_or_kwlist, %Options{}=opts) do
    map = cond do
            is_map(map_or_kwlist) -> map_or_kwlist
            is_list(map_or_kwlist) -> Enum.into(map_or_kwlist, %{})
            true -> raise "input must be a map or keyword list"
          end
    keys = struct |> Map.from_struct |> Map.keys
    Enum.reduce keys, struct, fn (atom, acc) ->
      str = to_string(atom)
      under_str = Mix.Utils.underscore(str)
      camel_str = Mix.Utils.camelize(str) |> ExConstructor.Utils.lcfirst
      under_atom = String.to_atom(under_str)
      camel_atom = String.to_atom(camel_str)
      value = cond do
        Map.has_key?(map, str) and opts.strings ->
          Map.get(map, str)
        Map.has_key?(map, atom) and opts.atoms ->
          Map.get(map, atom)
        Map.has_key?(map, under_str) and opts.strings and opts.underscore ->
          Map.get(map, under_str)
        Map.has_key?(map, under_atom) and opts.atoms and opts.underscore ->
          Map.get(map, under_atom)
        Map.has_key?(map, camel_str) and opts.strings and opts.camelcase ->
          Map.get(map, camel_str)
        Map.has_key?(map, camel_atom) and opts.atoms and opts.camelcase ->
          Map.get(map, camel_atom)
        true ->
          Map.get(struct, atom)
      end
      Map.put(acc, atom, value)
    end
  end

  def populate_struct(default, map, opts) do
    opts_struct = populate_struct(%Options{}, opts, %Options{})
    populate_struct(default, map, opts_struct)
  end


  defmodule Utils do
    @doc ~s"""
    Returns a copy of `str` with the first character lowercased.

        iex> ExConstructor.Utils.lcfirst("Adam's Mom")
        "adam's Mom"
    """
    def lcfirst(str) do
      first = String.slice(str, 0..0) |> String.downcase
      first <> String.slice(str, 1..-1)
    end



  end
end

