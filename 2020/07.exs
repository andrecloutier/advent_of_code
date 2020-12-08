defmodule Day7 do
  def contains?(mappings, current, target) do
    mappings
    |> Map.get(current)
    |> Map.keys()
    |> Enum.any?(fn k ->
      k == target || contains?(mappings, k, target)
    end)
  end

  def count_child_bags(mappings, current) do
    mappings
    |> Map.get(current)
    |> Enum.reduce(1, fn {k, count}, agg ->
      agg + count * count_child_bags(mappings, k)
    end)
  end
end

mappings =
  "07.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.reduce(%{}, fn line, m ->
    [one, two, _bags, _contain | rest] = line |> String.split(" ")
    rest
    |> Enum.chunk_every(4)
    |> Enum.reduce(%{}, fn parts, agg ->
      case parts do
        ["no", "other", "bags."] ->
          agg
        [num, child_one, child_two, _bag] ->
          Map.put(agg, "#{child_one} #{child_two}", String.to_integer(num))
      end
    end)
    |> (fn child_map -> Map.put(m, "#{one} #{two}", child_map) end).()
  end)

mappings
|> Map.keys()
|> Enum.count(fn k -> Day7.contains?(mappings, k, "shiny gold") end)
|> IO.inspect(label: "Part 1")

mappings
|> Day7.count_child_bags("shiny gold")
|> Kernel.-(1)
|> IO.inspect(label: "Part 2")