defmodule Day3 do
  def travel(_map, {_max_x, max_y}, {_x, y}, {_incr_x, _incr_y}, sum_trees) when y > max_y, do: sum_trees
  def travel(map, {max_x, max_y}, {x, y}, {incr_x, incr_y}, sum_trees) when x > max_x do
    x = rem(x, max_x+1)
    travel(map, {max_x, max_y}, {x, y}, {incr_x, incr_y}, sum_trees)
  end
  def travel(map, {max_x, max_y}, {x, y}, {incr_x, incr_y}, sum_trees) do
    char = Map.get(map, {x,y})
    sum_trees = if char == "#", do: sum_trees + 1, else: sum_trees
    travel(map, {max_x, max_y}, {x+incr_x, y+incr_y}, {incr_x, incr_y}, sum_trees)
  end
end

map =
  "03.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.reduce({0, %{}}, fn line, {y, agg} ->
    line
    |> String.codepoints()
    |> Enum.reduce({0, agg}, fn char, {x, agg2} ->
      {x+1, Map.put(agg2, {x, y}, char)}
    end)
    |> (fn {_, r} -> {y+1, r} end).()
  end)
  |> elem(1)

max_x = map |> Enum.map(fn {{x, _y}, _v} -> x end) |> Enum.max()
max_y = map |> Enum.map(fn {{_x, y}, _v} -> y end) |> Enum.max()

map
|> Day3.travel({max_x, max_y}, {0, 0}, {3, 1}, 0)
|> IO.inspect(label: "Part 1")

[{1, 1}, {3, 1}, {5,1}, {7,1}, {1, 2}]
|> Enum.reduce(1, fn incrs, mult ->
  mult * Day3.travel(map, {max_x, max_y}, {0, 0}, incrs, 0)
end)
|> IO.inspect(label: "Part 2")