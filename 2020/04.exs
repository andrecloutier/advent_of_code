defmodule Day4 do
  def validate("cid", _value, agg), do: agg
  def validate("byr" = k, value, agg) do
    case Integer.parse(value) do
      {num, ""} when num >= 1920 and num <= 2002 ->
        MapSet.put(agg, k)
      _ ->
        MapSet.put(agg, "invalid")
    end
  end
  def validate("iyr" = k, value, agg) do
    case Integer.parse(value) do
      {num, ""} when num >= 2010 and num <= 2020 ->
        MapSet.put(agg, k)
      _ ->
        MapSet.put(agg, "invalid")
    end
  end
  def validate("eyr" = k, value, agg) do
    case Integer.parse(value) do
      {num, ""} when num >= 2020 and num <= 2030 ->
        MapSet.put(agg, k)
      _ ->
        MapSet.put(agg, "invalid")
    end
  end
  def validate("hgt" = k, value, agg) do
    case Integer.parse(value) do
      {num, "cm"} when num >= 150 and num <= 193 ->
        MapSet.put(agg, k)
      {num, "in"} when num >= 59 and num <= 76 ->
        MapSet.put(agg, k)
      _ ->
        MapSet.put(agg, "invalid")
    end
  end
  def validate("hcl" = k, value, agg) do
    [head | rest] = String.codepoints(value)
    valid_chars = "0123456789abcdef" |> String.codepoints()
    if head == "#" && String.length(value) == 7 && Enum.all?(rest, fn c -> c in valid_chars end) do
      MapSet.put(agg, k)
    else
      MapSet.put(agg, "invalid")
    end
  end
  def validate("ecl" = k, value, agg) do
    valid = ["amb","blu","brn","gry","grn","hzl","oth"]
    if value in valid do
      MapSet.put(agg, k)
    else
      MapSet.put(agg, "invalid")
    end
  end
  def validate("pid" = k, value, agg) do
    rest = String.codepoints(value)
    valid_chars = "0123456789" |> String.codepoints()
    if Enum.all?(rest, fn c -> c in valid_chars end) && String.length(value) == 9 do
      MapSet.put(agg, k)
    else
      MapSet.put(agg, "invalid")
    end
  end
end

required_fields = ["byr","iyr","eyr","hgt","hcl","ecl","pid"] |> MapSet.new

"04.txt"
|> File.read!()
|> Kernel.<>("\n")
|> String.split("\n")
|> Enum.reduce({MapSet.new, 0}, fn line, {fields, count} ->
  line = String.trim(line)
  if line == "" do
    count = if MapSet.equal?(fields, required_fields), do: count + 1, else: count
    {MapSet.new, count}
  else
    line
    |> String.split(" ")
    |> Enum.map(fn part -> part |> String.split(":") |> Enum.at(0) end)
    |> Enum.reject(fn part -> part == "cid" end)
    |> Enum.reduce(fields, fn f, agg -> MapSet.put(agg, f) end)
    |> (fn new_fields -> {new_fields, count} end).()
  end
end)
|> elem(1)
|> IO.inspect(label: "Part One")

"04.txt"
|> File.read!()
|> Kernel.<>("\n")
|> String.split("\n")
|> Enum.reduce({MapSet.new, 0}, fn line, {fields, count} ->
  line = String.trim(line)
  if line == "" do
    count = if MapSet.equal?(fields, required_fields), do: count + 1, else: count
    {MapSet.new, count}
  else
    line
    |> String.split(" ")
    |> Enum.map(fn part -> part |> String.split(":") end)
    |> Enum.reduce(fields, fn [key, value], agg -> Day4.validate(key, value, agg) end)
    |> (fn new_fields -> {new_fields, count} end).()
  end
end)
|> elem(1)
|> IO.inspect(label: "Part Two")