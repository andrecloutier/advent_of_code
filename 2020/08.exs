defmodule Day8 do
  def recurse(program, visited, position, accumulator) do
    if MapSet.member?(visited, position) do
      accumulator
    else
      case Map.get(program, position) do
        {"acc", offset} -> recurse(program, MapSet.put(visited, position), position+1, accumulator+offset)
        {"jmp", offset} -> recurse(program, MapSet.put(visited, position), position+offset, accumulator)
        {"nop", _offset} -> recurse(program, MapSet.put(visited, position), position+1, accumulator)
      end
    end
  end

  def recurse_two(program, visited, position, accumulator, max_key) do
    if MapSet.member?(visited, position) do
      {:cont, nil}
    else
      case Map.get(program, position) do
        {"acc", offset} -> recurse_two(program, MapSet.put(visited, position), position+1, accumulator+offset, max_key)
        {"jmp", offset} -> recurse_two(program, MapSet.put(visited, position), position+offset, accumulator, max_key)
        {"nop", _offset} -> recurse_two(program, MapSet.put(visited, position), position+1, accumulator, max_key)
        nil -> if position == max_key+1, do: {:halt, accumulator}, else: {:cont, nil}
      end
    end
  end
end

program =
  "08.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.reduce({0, %{}}, fn line, {count, acc} ->
    [op, offset] = String.split(line, " ")
    acc = Map.put(acc, count, {op, String.to_integer(offset)})
    {count+1, acc}
  end)
  |> elem(1)

program
|> Day8.recurse(MapSet.new, 0, 0)
|> IO.inspect(label: "Part 1")

max_key = program |> Map.keys() |> Enum.max()

program
|> Enum.reduce_while(nil, fn {pos, {instruction, offset}}, _ ->
  case instruction do
    "jmp" -> Day8.recurse_two(Map.put(program, pos, {"nop", offset}), MapSet.new, 0, 0, max_key)
    "nop" -> Day8.recurse_two(Map.put(program, pos, {"jmp", offset}), MapSet.new, 0, 0, max_key)
    _ -> {:cont, nil}
  end
end)
|> IO.inspect(label: "Part 2")