defmodule ExConstructorTest do
  use ExSpec, async: true
  doctest ExConstructor
  doctest ExConstructor.Utils

  defmodule TestStruct do
    defstruct field_one: 1,
              field_two: 2,
              field_three: 3,
              field_four: 4,
              field_five: 5,
              Field_Six: 6
    ExConstructor.define_constructor
  end

  describe "define_constructor" do
    it "handles string-vs-atom and camel-vs-underscore" do
      map = %{"field_one" => "a", "fieldTwo" => "b", :field_three => "c",
              :fieldFour => "d", "Field_Six": "f"}
      struct = %TestStruct{field_one: "a", field_two: "b", field_three: "c",
                           field_four: "d", field_five: 5, Field_Six: "f"}
      assert(struct == TestStruct.new(map))
    end
  end


end

