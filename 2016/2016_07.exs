defmodule Stuff do
  def has_abba([a, b, b, a | _rest]) when a != b, do: true
  def has_abba([_head | tail]), do: has_abba(tail)
  def has_abba([]), do: false

  def extract_babs([a, b, a | rest], agg) when a != b do
    extract_babs([b, a | rest], MapSet.put(agg, "#{b}#{a}#{b}"))
  end
  def extract_babs([_head | tail], agg), do: extract_babs(tail, agg)
  def extract_babs([], agg), do: agg
end

"2016_07.in"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.count(fn line ->
  line
  |> String.split(["[", "]"])
  |> Enum.with_index()
  |> Enum.map(fn {part, index} ->
    has_abba =
      part
      |> String.codepoints()
      |> Stuff.has_abba()
    {index, has_abba}
  end)
  |> Enum.group_by(fn {n, _} -> rem(n ,2) end)
  |> Enum.all?(fn {n, bools} ->
    if n == 0 do
      # out of parens
      Enum.any?(bools, fn {_, b} -> b end)
    else
      # in parens
      Enum.all?(bools, fn {_, b} -> b == false end)
    end
  end)
end)
|> IO.inspect(label: "Part 1")

"2016_07.in"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.count(fn line ->
  %{0 => even, 1 => odds} =
    line
    |> String.split(["[", "]"])
    |> Enum.with_index()
    |> Enum.group_by(fn {_, n} -> rem(n ,2) end)

  # out of parens
  babs =
    even
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(MapSet.new, fn part, found_abas ->
      part
      |> String.codepoints()
      |> Stuff.extract_babs(found_abas)
    end)
    |> MapSet.to_list()

  # in parens
  odds
  |> Enum.map(&elem(&1, 0))
  |> Enum.any?(fn part ->
    Enum.any?(babs, fn bab -> String.contains?(part, bab) end)
  end)
end)
|> IO.inspect(label: "Part 2")