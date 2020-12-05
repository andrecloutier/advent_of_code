"05.txt"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  line
  |> String.codepoints()
  |> Enum.reduce({0.0, 127.0, 0.0, 7.0}, fn char, {row_low, row_high, col_low, col_high} ->
    case char do
      "F" -> {row_low, ((row_low + row_high + 1) / 2) - 1, col_low, col_high}
      "B" -> {((row_low + row_high + 1) / 2), row_high, col_low, col_high}
      "L" -> {row_low, row_high, col_low, ((col_low + col_high + 1) / 2) - 1}
      "R" -> {row_low, row_high, ((col_low + col_high + 1) / 2), col_high}
    end
  end)
end)
|> Enum.map(fn {row, row, col, col} -> trunc(row) * 8 + trunc(col) end)
|> Enum.max()
|> IO.inspect(label: "Part One")


seat_ids =
  "05.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    line
    |> String.codepoints()
    |> Enum.reduce({0.0, 127.0, 0.0, 7.0}, fn char, {row_low, row_high, col_low, col_high} ->
      case char do
        "F" -> {row_low, ((row_low + row_high + 1) / 2) - 1, col_low, col_high}
        "B" -> {((row_low + row_high + 1) / 2), row_high, col_low, col_high}
        "L" -> {row_low, row_high, col_low, ((col_low + col_high + 1) / 2) - 1}
        "R" -> {row_low, row_high, ((col_low + col_high + 1) / 2), col_high}
      end
    end)
  end)
  |> Enum.map(fn {row, row, col, col} -> trunc(row) * 8 + trunc(col) end)
  |> MapSet.new()

for r <- 0..127,
    c <- 0..7,
    reduce: nil do
  nil ->
    seat_id = r * 8 + c
    if !MapSet.member?(seat_ids, seat_id) && Enum.all?([seat_id-1, seat_id+1], &MapSet.member?(seat_ids, &1)), do: seat_id, else: nil
  val -> val
end
|> IO.inspect(label: "Part Two")
