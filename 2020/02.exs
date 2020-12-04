File.read!("02.txt")
|> String.split("\n", trim: true)
|> Enum.count(fn line ->
  [range, char, password] = String.split(line, " ")
  char = String.trim(char, ":")

  [r_low, r_high] =
    range
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)

  count =
    password
    |> String.codepoints()
    |> Enum.count(fn c -> c == char end)

  count >= r_low && count <= r_high
end)
|> IO.inspect(label: "Part 1")

File.read!("02.txt")
|> String.split("\n", trim: true)
|> Enum.count(fn line ->
  [range, char, password] = String.split(line, " ")
  char = String.trim(char, ":")

  pw_chars = password |> String.codepoints()

  match_count =
    range
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
    |> Enum.count(fn position ->
      Enum.at(pw_chars, position - 1) == char
    end)

  match_count == 1
end)
|> IO.inspect(label: "Part 2")