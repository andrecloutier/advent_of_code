[sections, my_ticket, nearby_tickets] =
  File.read!("16.txt")
  |> String.trim()
  |> String.split("\n\n")

set =
  sections
  |> String.split("\n")
  |> Enum.map(fn line -> Regex.run(~r/\s*: (\d*)-(\d*) or (\d*)-(\d*)/ ,line) |> tl() |> Enum.map(&String.to_integer/1) end)
  |> List.flatten()
  |> Enum.chunk_every(2)
  |> Enum.reduce(MapSet.new(), fn [a,b], agg -> MapSet.union(agg, MapSet.new(a..b)) end)

nearby_tickets
|> String.split("\n", trim: true)
|> tl()
|> Enum.map(fn line -> line |> String.split(",") |> Enum.map(&String.to_integer/1) end)
|> List.flatten()
|> Enum.map(fn n -> if MapSet.member?(set, n), do: 0, else: n end)
|> Enum.sum()
|> IO.inspect(label: "Part 1")

section_ranges =
  sections
  |> String.split("\n")
  |> Enum.map(fn line ->
    [_, name | ranges] = Regex.run(~r/([[:print:]]*): (\d*)-(\d*) or (\d*)-(\d*)/, line)

    range_set =
      ranges
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.reduce(MapSet.new(), fn [a,b], agg -> MapSet.union(agg, MapSet.new(a..b)) end)

    {name, range_set}
  end)

my_ticket_numbers =
  my_ticket
  |> String.split("\n")
  |> Enum.at(1)
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

nearby_tickets
|> String.split("\n", trim: true)
|> tl()
|> Enum.map(fn line -> line |> String.split(",") |> Enum.map(&String.to_integer/1) end)
|> Enum.filter(fn nums -> Enum.all?(nums, &MapSet.member?(set, &1)) end)
|> Enum.map(fn nums ->
  Enum.map(nums, fn num ->
    Enum.reduce(
      section_ranges,
      MapSet.new(),
      fn {name, range_set}, agg ->
        if MapSet.member?(range_set, num), do: MapSet.put(agg, name), else: agg
      end)
  end)
end)
|> Enum.zip()
|> Enum.map(fn t -> t |> Tuple.to_list() |> Enum.reduce(&MapSet.intersection/2) |> MapSet.to_list() end)
|> Enum.with_index()
|> Enum.sort_by(fn {list, _} -> Enum.count(list) end)
|> Enum.reduce({MapSet.new, []}, fn {list, count}, {seen, results} ->
  [res] = list |> Enum.reject(&MapSet.member?(seen, &1))
  {MapSet.put(seen, res), [{res, count} | results]}
end)
|> elem(1)
|> Enum.reduce(1, fn {name, position}, agg ->
  if String.starts_with?(name, "departure"), do: agg * Enum.at(my_ticket_numbers, position), else: agg
end)
|> IO.inspect(label: "Part 2")