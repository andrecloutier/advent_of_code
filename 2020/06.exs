"06.txt"
|> File.read!()
|> Kernel.<>("\n")
|> String.split("\n")
|> Enum.reduce({0, MapSet.new}, fn line, {sum, chars} ->
  if line == "" do
    len = if is_nil(chars), do: 0, else: MapSet.size(chars)
    {sum + len, MapSet.new}
  else
    chars_map = line |> String.codepoints() |> MapSet.new()
    {sum, MapSet.union(chars, chars_map)}
  end
end)
|> elem(0)
|> IO.inspect(label: "Part One")

"06.txt"
|> File.read!()
|> Kernel.<>("\n")
|> String.split("\n")
|> Enum.reduce({0, nil}, fn line, {sum, chars} ->
  if line == "" do
    len = if is_nil(chars), do: 0, else: MapSet.size(chars)
    {sum + len, nil}
  else
    chars_map = line |> String.codepoints() |> MapSet.new()
    new_chars = if is_nil(chars), do: chars_map, else: MapSet.intersection(chars, chars_map)
    {sum, new_chars}
  end
end)
|> elem(0)
|> IO.inspect(label: "Part Two")