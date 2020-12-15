defmodule Day15 do
  def recurse(final_turn, final_turn, last_num, _counts), do: last_num
  def recurse(final_turn, turn, last_num, counts) do
    if Map.has_key?(counts, last_num) do
      turn_delta = turn - Map.get(counts, last_num) - 1
      recurse(final_turn, turn+1, turn_delta, Map.put(counts, last_num, turn-1))
    else
      recurse(final_turn, turn+1, 0, Map.put(counts, last_num, turn-1))
    end
  end
end

{head, [last]} =
  File.read!("15.txt")
  |> String.trim()
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)
  |> Enum.split(-1)

initial_counts =
  head
  |> Enum.with_index(1)
  |> Enum.reduce(%{}, fn {val, idx},acc -> Map.put(acc, val, idx) end)

Day15.recurse(2021, map_size(initial_counts)+2, last, initial_counts)
|> IO.inspect(label: "Part 1")

Day15.recurse(30000001, map_size(initial_counts)+2, last, initial_counts)
|> IO.inspect(label: "Part 2")