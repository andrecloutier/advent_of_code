defmodule Day11 do
  @adjacent_deltas [{-1, -1}, {-1, 0}, {-1, 1}, {1, -1}, {1, 0}, {1, 1}, {0, -1}, {0, 1}]

  # Part One

  def recurse(previous_board, false), do: previous_board
  def recurse(previous_board, true) do
    Enum.reduce(previous_board, {false, previous_board}, fn {{x,y}, char}, {was_modified, agg_board} ->
      adjacent_seats = Enum.count(@adjacent_deltas, fn {dx, dy} -> Map.get(previous_board, {x+dx, y+dy}) == "#" end)
      cond do
        char == "#" and adjacent_seats >= 4 -> {true, Map.put(agg_board, {x, y}, "L")}
        char == "L" and adjacent_seats == 0 -> {true, Map.put(agg_board, {x, y}, "#")}
        true -> {was_modified, agg_board}
      end
    end)
    |> (fn {was_modified, agg_board} -> recurse(agg_board, was_modified) end).()
  end

  # Part Two

  def recurse_two(previous_board, _max_xy, false), do: previous_board
  def recurse_two(previous_board, max_xy, true) do
    Enum.reduce(previous_board, {false, previous_board}, fn {{x,y}, char}, {was_modified, agg_board} ->
      adjacent_seats = Enum.count(@adjacent_deltas, fn delta -> has_adjacent?(previous_board, {x,y}, delta, max_xy) end)
      cond do
        char == "#" and adjacent_seats >= 5 -> {true, Map.put(agg_board, {x, y}, "L")}
        char == "L" and adjacent_seats == 0 -> {true, Map.put(agg_board, {x, y}, "#")}
        true -> {was_modified, agg_board}
      end
    end)
    |> (fn {was_modified, agg_board} -> recurse_two(agg_board, max_xy, was_modified) end).()
  end

  def has_adjacent?(board, {pos_x, pos_y}, {dx, dy}, {max_x, max_y}) do
    new_x = pos_x + dx
    new_y = pos_y + dy
    char = Map.get(board, {new_x, new_y})
    cond do
      new_x < 0 || new_x > max_x || new_y < 0 || new_y > max_y -> false
      char == "#" -> true
      char == "L" -> false
      true -> has_adjacent?(board, {new_x, new_y}, {dx, dy}, {max_x, max_y})
    end
  end

  # Debug functions

  def print_board(board, {max_x, max_y}) do
    IO.puts("=====")
    Enum.each(0..max_y, fn y ->
      Enum.map(0..max_x, fn x ->
        Map.get(board, {x, y}, ".")
      end)
      |> Enum.join()
      |> IO.puts()
    end)
  end

  def print_counts(board, {max_x, max_y}) do
    IO.puts("=====")
    Enum.each(0..max_y, fn y ->
      Enum.map(0..max_x, fn x ->
        Enum.count(@adjacent_deltas, fn delta -> has_adjacent?(board, {x,y}, delta, {max_x, max_y}) end)
      end)
      |> Enum.join()
      |> IO.puts()
    end)
  end
end


board =
  File.read!("11.txt")
  |> String.split("\n", trim: true)
  |> Enum.with_index()
  |> Enum.reduce(%{}, fn {line, y_index}, agg ->
    line
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.reduce(agg, fn {char, x_index}, agg2 ->
      if char != ".", do: Map.put(agg2, {x_index, y_index}, char), else: agg2
    end)
  end)

max_x = board |> Enum.map(fn {{x, _y}, _} -> x end) |> Enum.max()
max_y = board |> Enum.map(fn {{_x, y}, _} -> y end) |> Enum.max()

board
|> Day11.recurse(true)
|> Enum.count(fn {_, c} -> c == "#" end)
|> IO.inspect(label: "Part One")

board
|> Day11.recurse_two({max_x, max_y}, true)
|> Enum.count(fn {_, c} -> c == "#" end)
|> IO.inspect(label: "Part Two")
