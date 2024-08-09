defmodule Bichu.DictTest do
  use Bichu.DataCase

  describe "search/1" do
    test "search for a word which exists" do
      assert Bichu.Dict.search(".net") == %{
               english_entry: ".net",
               malayalam_definition: "പുത്തൻ കമ്പ്യൂട്ടർ സാങ്കേതികത ഭാഷ",
               part_of_speech: "{n}"
             }
    end

    test "search for a word which not exists" do
      assert Bichu.Dict.search(".nett") == "tiger"
    end
  end
end
