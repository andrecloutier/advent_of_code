defmodule Day14 do
  def number_to_binary(number) do
    number
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.codepoints()
  end

  def binary_to_integer(binary) do
    binary
    |> Enum.join()
    |> String.to_integer(2)
  end

  def compute_all_permutations(["X"]), do: [["1"], ["0"]]
  def compute_all_permutations([bit]), do: [[bit]]
  def compute_all_permutations([bit | rest]) do
    children = compute_all_permutations(rest)
    if bit == "X" do
      ["1", "0"]
      |> Enum.map(fn real_bit -> Enum.map(children, fn child -> [real_bit | child] end) end)
      |> (fn [ones, zeroes] -> ones ++ zeroes end).()
    else
      Enum.map(children, fn child -> [bit | child] end)
    end
  end
end

commands =
  File.read!("14.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    if String.starts_with?(line, "mask =") do
      {:mask, line |> String.split("= ") |> Enum.at(1) |> String.codepoints()}
    else
      [_, pos, value] = Regex.run(~r/\s*\[(\d*)\] = (\d*)/, line)
      {:mem, String.to_integer(pos), String.to_integer(value)}
    end
  end)

## PART 1
part_one_default_mask = "" |> String.pad_leading(36, "X") |> String.codepoints()
commands
|> Enum.reduce({part_one_default_mask, %{}}, fn command, {mask, mem} ->
  case command do
    {:mask, new_mask} ->
      {new_mask, mem}

    {:mem, pos, value} ->
      value
      |> Day14.number_to_binary()
      |> Enum.zip(mask)
      |> Enum.map(fn {bit, bitmask} -> if bitmask == "X", do: bit, else: bitmask end)
      |> (fn new_binary_number -> {mask, Map.put(mem, pos, Day14.binary_to_integer(new_binary_number))} end).()
  end
end)
|> elem(1)
|> Map.values()
|> Enum.sum()
|> IO.inspect(label: "Part One")

## PART 2
part_two_default_mask = "" |> String.pad_leading(36, "0") |> String.codepoints()
commands
|> Enum.reduce({part_two_default_mask, %{}}, fn command, {mask, mem} ->
  case command do
    {:mask, new_mask} ->
      {new_mask, mem}

    {:mem, pos, value} ->
      pos
      |> Day14.number_to_binary()
      |> Enum.zip(mask)
      |> Enum.map(fn {bit, bitmask} -> if bitmask == "0", do: bit, else: bitmask end)
      |> Day14.compute_all_permutations()
      |> Enum.reduce(mem, fn permutation, mem_acc ->
        Map.put(mem_acc, Day14.binary_to_integer(permutation), value)
      end)
      |> (fn new_mem -> {mask, new_mem} end).()
  end
end)
|> elem(1)
|> Map.values()
|> Enum.sum()
|> IO.inspect(label: "Part Two")