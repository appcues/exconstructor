defmodule ExConstructorTest do
  use ExUnit.Case, async: true
  doctest ExConstructor

  defmodule TestStruct do
    defstruct field_one: 1,
              field_two: 2,
              field_three: 3,
              field_four: 4,
              field_five: 5,
              Field_Six: 6,
              FieldSeven: 7,
              FieldEight: 8,
              field_nine: 9

    use ExConstructor
  end

  describe "populate_struct" do
    import ExConstructor

    test "handles maps with string-vs-atom, camel-vs-underscore, and literals" do
      map = %{
        "field_one" => "a",
        "fieldTwo" => "b",
        :field_three => "c",
        :fieldFour => "d",
        "Field_Six" => "f",
        "field_seven" => 7,
        :field_eight => 8,
        "FieldNine" => "Nine"
      }

      struct = %TestStruct{
        field_one: "a",
        field_two: "b",
        field_three: "c",
        field_four: "d",
        field_five: 5,
        Field_Six: "f",
        FieldSeven: 7,
        FieldEight: 8,
        field_nine: "Nine"
      }

      assert(struct == populate_struct(%TestStruct{}, map, []))
    end

    test "handles keyword lists" do
      kwlist = [{:field_one, "a"}, {"field_two", "b"}]

      struct = %TestStruct{
        field_one: "a",
        field_two: "b",
        field_three: 3,
        field_four: 4,
        field_five: 5,
        Field_Six: 6,
        FieldSeven: 7,
        FieldEight: 8,
        field_nine: 9
      }

      assert(struct == populate_struct(%TestStruct{}, kwlist, []))
    end

    test "converts opts into %Options{}" do
      ts =
        populate_struct(
          %TestStruct{},
          %{"field_one" => 11, :field_two => 22},
          strings: false
        )

      assert(11 != ts.field_one)
      assert(22 == ts.field_two)
    end

    test "defaults to %Options{} when none given" do
      ts =
        populate_struct(
          %TestStruct{},
          %{"field_one" => 11, :field_two => 22}
        )

      assert(11 == ts.field_one)
      assert(22 == ts.field_two)
    end

    test "blows up on bad input" do
      ex = assert_raise(RuntimeError, fn -> populate_struct(:omg, %{}, []) end)
      assert(String.match?(ex.message, ~r"first argument"))

      ex = assert_raise(RuntimeError, fn -> populate_struct(%TestStruct{}, :hi, []) end)
      assert(String.match?(ex.message, ~r"^second argument"))

      ex = assert_raise(RuntimeError, fn -> populate_struct(%TestStruct{}, %{}, :oof) end)
      assert(String.match?(ex.message, ~r"^third argument"))
    end
  end

  describe "invocation styles" do
    defmodule TestStruct1 do
      defstruct field: nil
      ExConstructor.define_constructor()
    end

    defmodule TestStruct2 do
      defstruct field: nil
      use ExConstructor
    end

    defmodule TestStruct3 do
      defstruct field: nil
      use ExConstructor, :make
    end

    defmodule TestStruct4 do
      defstruct field: nil
      use ExConstructor, name: :build
    end

    defmodule TestStruct5 do
      defstruct field: nil
      ExConstructor.__using__()
    end

    test "ExConstructor.define_constructor - uses the default constructor name" do
      assert(nil != TestStruct1.new(%{}))
    end

    test "use ExConstructor - uses the default constructor name" do
      assert(nil != TestStruct2.new(%{}))
    end

    test "use ExConstructor, :constructor_name - uses the given constructor name" do
      assert(nil != TestStruct3.make(%{}))
    end

    test "use ExConstructor, name: :constructor_name - uses the given constructor name" do
      assert(nil != TestStruct4.build(%{}))
    end

    test "ExConstructor.__using__ - uses the default constructor name" do
      assert(nil != TestStruct5.new(%{}))
    end

    test "raises exception on bad invocation" do
      ex =
        assert_raise(RuntimeError, fn ->
          defmodule TestStruct6 do
            defstruct field: nil
            ExConstructor.__using__(22)
          end
        end)

      assert(String.match?(ex.message, ~r"^argument must be"))
    end

    test "does not crash if @enforce_keys exists" do
      defmodule TestStruct7 do
        @enforce_keys :field
        defstruct field: 1
        use ExConstructor
      end
    end
  end

  describe "options" do
    defmodule TestStructNoStrings do
      defstruct foo: 1
      use ExConstructor, strings: false
    end

    defmodule TestStructNoAtoms do
      defstruct foo: 1
      use ExConstructor, atoms: false
    end

    defmodule TestStructNoCamel do
      defstruct foo_bar: 1
      use ExConstructor, camelcase: false
    end

    defmodule TestStructNoUpperCamel do
      defstruct foo_bar: 1
      use ExConstructor, uppercamelcase: false
    end

    defmodule TestStructNoUnder do
      defstruct fooBar: 1
      use ExConstructor, underscore: false
    end

    test "supports strings: false" do
      ts_map = TestStructNoStrings.new(%{"foo" => 2})
      assert(1 == ts_map.foo)
      ts_kwlist = TestStructNoStrings.new([{"foo", 2}])
      assert(1 == ts_kwlist.foo)
    end

    test "supports atoms: false" do
      ts_map = TestStructNoAtoms.new(%{:foo => 2})
      assert(1 == ts_map.foo)
      ts_kwlist = TestStructNoAtoms.new([{:foo, 2}])
      assert(1 == ts_kwlist.foo)
    end

    test "supports camelcase: false" do
      ts_map = TestStructNoCamel.new(%{:fooBar => 2})
      assert(1 == ts_map.foo_bar)
      ts_kwlist = TestStructNoCamel.new([{"fooBar", 2}])
      assert(1 == ts_kwlist.foo_bar)
    end

    test "supports uppercamelcase: false" do
      ts_map = TestStructNoUpperCamel.new(%{:FooBar => 2})
      assert(1 == ts_map.foo_bar)
      ts_kwlist = TestStructNoUpperCamel.new([{"FooBar", 2}])
      assert(1 == ts_kwlist.foo_bar)
    end

    test "supports underscore: false" do
      ts_map = TestStructNoUnder.new(%{:foo_bar => 2})
      assert(1 == ts_map.fooBar)
      ts_kwlist = TestStructNoUnder.new([{"foo_bar", 2}])
      assert(1 == ts_kwlist.fooBar)
    end

    test "supports overrides" do
      ts_map = TestStructNoStrings.new(%{"foo" => 2})
      assert(1 == ts_map.foo)
      ts_map = TestStructNoStrings.new(%{"foo" => 2}, strings: true)
      assert(2 == ts_map.foo)
    end
  end

  describe "overriding" do
    defmodule TestStructOverrideNew do
      defstruct [:name]
      use ExConstructor

      def new(data, args \\ []) do
        res = super(data, args)
        %{res | name: String.capitalize(res.name)}
      end
    end

    test "can override new and call super" do
      ts_map = TestStructOverrideNew.new(%{"name" => "jim"})
      assert("Jim" == ts_map.name)
    end
  end
end
