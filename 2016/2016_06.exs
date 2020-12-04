min_max =
  "2016_06.in"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.reduce(%{}, fn line, agg ->
    line
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.reduce(agg, fn {char, index}, agg2 ->
      row_counts = Map.get(agg2, index, %{})
      Map.put(agg2, index, Map.update(row_counts, char, 1, fn v -> v + 1 end))
    end)
  end)
  |> Enum.to_list()
  |> Enum.sort()
  |> Enum.map(fn {_idx, counts} ->
    counts
    |> Enum.min_max_by(fn {_char, count} -> count end)
    |> Tuple.to_list()
    |> Enum.map(&elem(&1, 0))
  end)

min_max
|> Enum.map(&Enum.at(&1, 1))
|> Enum.join()
|> IO.inspect(label: "Part 1")

min_max
|> Enum.map(&Enum.at(&1, 0))
|> Enum.join()
|> IO.inspect(label: "Part 2")