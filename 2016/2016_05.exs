door_id = "abbhdwsy"

#iex(2)> :crypto.hash(:md5, "abc3231929") |> Base.encode16()
#"00000155F8105DFF7F56EE10FA9B9ABD"

defmodule Day5 do
  def part1(_door_id, _num, length) when length == 8, do: []
  def part1(door_id, num, length) do
    input = "#{door_id}#{num}"
    hash = :crypto.hash(:md5, input) |> Base.encode16()
    if String.starts_with?(hash, "00000") do
      char = hash |> String.at(5) |> String.downcase()
      [char | part1(door_id, num+1, length+1)]
    else
      part1(door_id, num+1, length)
    end
  end

  def part2(_door_id, _num, chars) when map_size(chars) == 8, do: chars
  def part2(door_id, num, chars_found) do
    input = "#{door_id}#{num}"
    hash = :crypto.hash(:md5, input) |> Base.encode16()
    if String.starts_with?(hash, "00000") do
      index = hash |> String.at(5) |> String.downcase()

      case Integer.parse(index) do
        {pos, ""} when pos >= 0 and pos <= 7 ->
          char = hash |> String.at(6) |> String.downcase()
          chars_found = Map.put_new(chars_found, pos, char)
          part2(door_id, num+1, chars_found)
        _ ->
         part2(door_id, num+1, chars_found)
      end
    else
      part2(door_id, num+1, chars_found)
    end
  end
end

door_id
|> Day5.part1(0, 0)
|> Enum.join()
|> IO.inspect(label: "Part 1")

door_id
|> Day5.part2(0, %{})
|> Enum.to_list()
|> Enum.sort()
|> Enum.map(fn {_idx, c} -> c end)
|> Enum.join()
|> IO.inspect(label: "Part 2")
