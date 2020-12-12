directions =
  File.read!("12.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    {direction, number} = String.split_at(line, 1)
    {direction, String.to_integer(number)}
  end)

directions
|> Enum.reduce({0, {0, 0}}, fn {direction, num}, {heading, {pos_x, pos_y}} ->
  direction = if direction == "F", do: Enum.at(["E", "S", "W", "N"], heading), else: direction

  case direction do
    "N" -> {heading, {pos_x, pos_y+num}}
    "S" -> {heading, {pos_x, pos_y-num}}
    "E" -> {heading, {pos_x+num, pos_y}}
    "W" -> {heading, {pos_x-num, pos_y}}
    "L" ->
      new_head = heading - trunc(num / 90)
      new_head = if new_head < 0, do: new_head + 4, else: rem(new_head, 4)
      {new_head, {pos_x, pos_y}}
    "R" ->
      new_head = heading + trunc(num / 90)
      new_head = if new_head < 0, do: new_head + 4, else: rem(new_head, 4)
      {new_head, {pos_x, pos_y}}
  end
end)
|> (fn {_, {x, y}} -> abs(x) + abs(y) end).()
|> IO.inspect(label: "Part One")

directions
|> Enum.reduce({{0, 0}, {10, 1}}, fn {direction, num}, {{pos_x, pos_y}, {way_x, way_y}} ->
  case direction do
    "N" -> {{pos_x, pos_y}, {way_x, way_y+num}}
    "S" -> {{pos_x, pos_y}, {way_x, way_y-num}}
    "E" -> {{pos_x, pos_y}, {way_x+num, way_y}}
    "W" -> {{pos_x, pos_y}, {way_x-num, way_y}}
    "L" ->
      num_rotations = trunc(num / 90)
      new_way = Enum.reduce(1..num_rotations, {way_x, way_y}, fn _, {x, y} -> {y*-1, x} end)
      {{pos_x, pos_y}, new_way}
    "R" ->
      # {1, 10} -> {10, -1} -> {-1, -10} -> {-10, 1} -> {1, 10}
      num_rotations = trunc(num / 90)
      new_way = Enum.reduce(1..num_rotations, {way_x, way_y}, fn _, {x, y} -> {y, x*-1} end)
      {{pos_x, pos_y}, new_way}
    "F" -> {{pos_x+way_x*num, pos_y+way_y*num}, {way_x, way_y}}
  end
end)
|> (fn {{x, y}, _} -> abs(x) + abs(y) end).()
|> IO.inspect(label: "Part Two")