# A room is real (not a decoy) if the checksum is the five
# most common letters in the encrypted name, in order, with ties broken by alphabetization.
# aaaaa-bbb-z-y-x-123[abxyz]

File.read!("2016_04.in")
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  [f, l] = String.split(line, "[")
  checksum = String.trim(l, "]")

  parts = String.split(f, "-")
  sector_id = Enum.at(parts, -1) |> String.to_integer()
  computed_checksum =
    parts
    |> List.delete_at(-1)
    |> Enum.join()
    |> String.codepoints()
    |> Enum.reduce(%{}, fn letter, acc ->
      count = Map.get(acc, letter, 0) + 1
      Map.put(acc, letter, count)
    end)
    |> Enum.to_list()
    |> Enum.sort_by(fn {char, count} -> {count, -1 * :binary.first(char)} end, &>=/2)
    |> Enum.take(5)
    |> Enum.map(fn {char, _count} -> char end)
    |> Enum.join()

  if computed_checksum == checksum do
    sector_id
  else
    0
  end
end)
|> Enum.sum()
|> IO.inspect(label: "Part One")


File.read!("2016_04.in")
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  [f, l] = String.split(line, "[")
  checksum = String.trim(l, "]")

  parts = String.split(f, "-")
  sector_id = Enum.at(parts, -1) |> String.to_integer()
  words = parts |> List.delete_at(-1)
  computed_checksum =
    words
    |> Enum.join()
    |> String.codepoints()
    |> Enum.reduce(%{}, fn letter, acc ->
      count = Map.get(acc, letter, 0) + 1
      Map.put(acc, letter, count)
    end)
    |> Enum.to_list()
    |> Enum.sort_by(fn {char, count} -> {count, -1 * :binary.first(char)} end, &>=/2)
    |> Enum.take(5)
    |> Enum.map(fn {char, _count} -> char end)
    |> Enum.join()

  if computed_checksum == checksum do
    decoded_sentence =
      words
      |> Enum.map(fn word ->
        word
        |> String.codepoints()
        |> Enum.map(fn letter ->
          rem(:binary.first(letter) - 97 + sector_id, 26) + 97
        end)
        |> List.to_string()
      end)
      |> Enum.join(" ")
    {decoded_sentence, sector_id}
  else
    nil
  end
end)
|> Enum.reject(&is_nil/1)
|> Enum.find(fn {sentence, _} -> String.contains?(sentence, "pole") end)
|> IO.inspect(label: "Part Two")
