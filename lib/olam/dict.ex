defmodule Olam.Dict do
  @moduledoc """
  Dictionary search interface using ETS cache.
  """

  @doc """
  Search for English words with fuzzy matching.
  Falls back to file-based search if cache is not ready.
  """
  def search(%{"query" => word}) do
    case Olam.FastDictCache.search_prefix(word) do
      {:error, :cache_not_ready} ->
        # Fallback to original implementation
        fallback_search(word)
      results ->
        results
    end
  end

  # Original implementation as fallback
  defp fallback_search(word) do
    NimbleCSV.define(CSV, separator: "\t", escape: "\"")

    File.stream!("priv/csv/enml")
    |> CSV.parse_stream()
    |> Enum.map(fn [english_entry, part_of_speech, malayalam_definition] ->
      %{
        english_entry: english_entry,
        part_of_speech: part_of_speech,
        malayalam_definition: malayalam_definition
      }
    end)
    |> Seqfuzz.filter(word, fn x -> x.english_entry end)
    |> Enum.take(5)
  end
end
