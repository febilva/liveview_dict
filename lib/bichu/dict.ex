defmodule Bichu.Dict do
  NimbleCSV.define(CSV, separator: "\t", escape: "\"")

  def search(word) do
    File.stream!("priv/csv/enml")
    |> CSV.parse_stream()
    |> Enum.map(fn [english_entry, part_of_speech, malayalam_definition] ->
      %{
        english_entry: english_entry,
        part_of_speech: part_of_speech,
        malayalam_definition: malayalam_definition
      }
    end)
    |> Enum.find(fn entry -> entry.english_entry == word end)
  end
end
