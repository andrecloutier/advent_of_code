defmodule Day10 do
  def recurse([], _prev, agg), do: Map.update!(agg, 3, &(&1 + 1))
  def recurse([h | rest], previous, agg) do
    delta = h - previous
    recurse(rest, h, Map.update!(agg, delta, &(&1 + 1)))
  end

  def recurse_two([], _, cache), do: {cache, 1}
  def recurse_two(list, previous, cache) do
    Enum.reduce_while(list, {cache, 0}, fn l, {c, agg} ->
      cond do
        l > previous+3 -> {:halt, {c, agg}}
        Map.has_key?(c, l) -> {:cont, {c, agg + Map.get(c, l)}}
        true ->
          {_, r} = Enum.split_while(list, fn x -> x <= l end)
          {c, rec} = recurse_two(r, l, c)
          {:cont, {Map.put(c, l, rec), agg + rec}}
      end
    end)
  end
end


input =
  File.read!("10.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.sort()

input
|> Day10.recurse(0, %{1 => 0, 3 => 0})
|> (fn %{1 => one, 3 => three} -> one * three end).()
|> IO.inspect(label: "Part One")

input
|> Day10.recurse_two(0, %{})
|> elem(1)
|> IO.inspect(label: "Part Two")
