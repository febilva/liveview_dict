defmodule Olam.FastDictCache do
  use GenServer

  @table_name :olam_dict_cache

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # FASTEST: Direct ETS lookup - O(1)
  def get_exact(english_word) do
    case :ets.lookup(@table_name, {:exact, String.downcase(english_word)}) do
      [{_, entry}] -> {:ok, entry}
      [] -> {:not_found}
    end
  end

  # FAST: Prefix search using ETS select
  def search_prefix(prefix, limit \\ 20) do
    prefix_lower = String.downcase(prefix) |> IO.inspect(label: "prefix_lower")

    :ets.select(@table_name, [
      {{{:prefix, :"$1"}, :"$2"},
       [{:andalso, {:>=, {:byte_size, :"$1"}, byte_size(prefix_lower)},
         {:==, {:binary_part, :"$1", 0, byte_size(prefix_lower)}, prefix_lower}}],
       [:"$2"]}
    ])
    |> Seqfuzz.filter(prefix, fn x -> x.english_entry end)
    |> Enum.take(10)
  end

  # MODERATE: Full fuzzy search (only when needed)
  def search_fuzzy(word, limit \\ 5) do
    # Get all entries using select (faster than tab2list)
    all_entries = :ets.select(@table_name, [
      {{{:index, :_}, :"$1"}, [], [:"$1"]}
    ])

    Seqfuzz.filter(all_entries, word, fn x -> x.english_entry end)
    |> Enum.take(limit)
  end

  @impl true
  def init(_) do
    create_optimized_table()
    {:ok, %{}}
  end

  defp create_optimized_table do
    # Forum-recommended configuration for read performance
    :ets.new(@table_name, [
      :named_table,
      :bag,  # Multiple indexing strategies
      :protected,  # As recommended in forum
      read_concurrency: true,  # Critical for performance
      write_concurrency: false
    ])

    load_with_multiple_indexes()
  end

  defp load_with_multiple_indexes do
    NimbleCSV.define(CSV, separator: "\t", escape: "\"")

    File.stream!("priv/csv/enml")
    |> CSV.parse_stream()
    |> Stream.with_index()
    |> Enum.each(fn {[english, pos, malayalam], index} ->
      entry = %{
        english_entry: english,
        part_of_speech: pos,
        malayalam_definition: malayalam
      }

      # Multiple indexing strategies for different access patterns
      english_lower = String.downcase(english)

      # 1. Exact lookup (fastest)
      :ets.insert(@table_name, {{:exact, english_lower}, entry}) |> IO.inspect(label: "insert exact")

      # 2. Index for fuzzy search
      :ets.insert(@table_name, {{:index, index}, entry})

      # 3. Prefix indexing for fast prefix search
      :ets.insert(@table_name, {{:prefix, english_lower}, entry})
    end)
  end
end
