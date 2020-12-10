defmodule Day9 do
  def recurse({preamble, [num | rest]}) do
    set = MapSet.new(preamble)
    if Enum.any?(preamble, fn n -> MapSet.member?(set, num - n) end) do
      [_ | preamble_rest] = preamble
      recurse({preamble_rest ++ [num], rest})
    else
      num
    end
  end

  def recurse_two([head | rest], agg_sum, agg_list, target) do
    agg_sum = agg_sum + head
    agg_list = [head | agg_list]
    cond do
      agg_sum == target -> agg_list |> Enum.min_max() |> Tuple.to_list() |> Enum.sum()
      agg_sum > target -> nil
      true -> recurse_two(rest, agg_sum, agg_list, target)
    end
  end
end

inputs =
  File.read!("09.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)

solution_one =
  inputs
  |> Enum.split(25)
  |> Day9.recurse()
  |> IO.inspect(label: "Part 1")

inputs
|> Enum.reduce_while(inputs, fn _, [_ | rest] = list ->
  case Day9.recurse_two(list, 0, [], solution_one) do
    nil -> {:cont, rest}
    res -> {:halt, res}
  end
end)
|> IO.inspect(label: "Part 2")
