defmodule Olam.DictTest do
  use Olam.DataCase

  describe "search/1" do
    test "search for a word which exists" do
      assert Olam.Dict.search(".net") == %{
               english_entry: ".net",
               malayalam_definition: "പുത്തൻ കമ്പ്യൂട്ടർ സാങ്കേതികത ഭാഷ",
               part_of_speech: "{n}"
             }
    end

    test "search for a word which not exists" do
      assert Olam.Dict.search(".nett") == "tiger"
    end
  end
end
