defmodule Day1 do
  def recurse([current | rest], lookup, target) do
    other = target - current
    if MapSet.member?(lookup, other) do
      current * other
    else
      recurse(rest, lookup, target)
    end
  end
  def recurse([], _, _), do: nil

  def recurse_two([current | rest], lookup) do
    target = 2020 - current
    result = recurse(rest, MapSet.delete(lookup, current), target)
    if is_nil(result) do
      recurse_two(rest, lookup)
    else
      current * result
    end
  end
end

inputs =
  File.read!("01.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)

inputs
|> Day1.recurse(MapSet.new(inputs), 2020)
|> IO.inspect(label: "Part 1")

inputs
|> Day1.recurse_two(MapSet.new(inputs))
|> IO.inspect(label: "Part 2")