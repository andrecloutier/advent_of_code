input = "L4, L1, R4, R1, R1, L3, R5, L5, L2, L3, R2, R1, L4, R5, R4, L2, R1, R3, L5, R1, L3, L2, R5, L4, L5, R1, R2, L1, R5, L3, R2, R2, L1, R5, R2, L1, L1, R2, L1, R1, L2, L2, R4, R3, R2, L3, L188, L3, R2, R54, R1, R1, L2, L4, L3, L2, R3, L1, L1, R3, R5, L1, R5, L1, L1, R2, R4, R4, L5, L4, L1, R2, R4, R5, L2, L3, R5, L5, R1, R5, L2, R4, L2, L1, R4, R3, R4, L4, R3, L4, R78, R2, L3, R188, R2, R3, L2, R2, R3, R1, R5, R1, L1, L1, R4, R2, R1, R5, L1, R4, L4, R2, R5, L2, L5, R4, L3, L2, R1, R1, L5, L4, R1, L5, L1, L5, L1, L4, L3, L5, R4, R5, R2, L5, R5, R5, R4, R2, L1, L2, R3, R5, R5, R5, L2, L1, R4, R3, R1, L4, L2, L3, R2, L3, L5, L2, L2, L1, L2, R5, L2, L2, L3, L1, R1, L4, R2, L4, R3, R5, R3, R4, R1, R5, L3, L5, L5, L3, L2, L1, R3, L4, R3, R2, L1, R3, R1, L2, R4, L3, L3, L3, L1, L2"

directions = %{
  0 => {0, 1},
  1 => {1, 0},
  2 => {0, -1},
  3 => {-1, 0}
}

{x, y, _} =
  input
  |> String.split(", ", trim: true)
  |> Enum.map(fn s ->
    {direction, num} = String.split_at(s, 1)
    {direction, String.to_integer(num)}
  end)
  |> Enum.reduce({0,0,0}, fn {direction, num}, {x,y,direction_num} ->
    new_direction = if direction == "L", do: direction_num-1, else: rem(direction_num+1, 4)
    new_direction = if new_direction == -1, do: 3, else: new_direction

    {dir_x, dir_y} = Map.get(directions, new_direction)
    {x+(dir_x*num), y+(dir_y*num), new_direction}
  end)

IO.inspect(x+y, label: "Part 1")


input
|> String.split(", ", trim: true)
|> Enum.map(fn s ->
  {direction, num} = String.split_at(s, 1)
  {direction, String.to_integer(num)}
end)
|> Enum.reduce_while({0,0,0,MapSet.new()}, fn {direction, num}, {x,y,direction_num,visited} ->
  new_direction = if direction == "L", do: direction_num-1, else: rem(direction_num+1, 4)
  new_direction = if new_direction == -1, do: 3, else: new_direction

  {dir_x, dir_y} = Map.get(directions, new_direction)
  result = Enum.reduce_while(1..num, {x,y,direction_num,visited}, fn _num, {x,y,_direction_num,visited} ->
    new_x = x+dir_x
    new_y = y+dir_y
    if MapSet.member?(visited, {new_x, new_y}) do
      {:halt, {:halt, new_x+new_y}}
    else
      {:cont, {new_x, new_y, new_direction, MapSet.put(visited, {new_x, new_y})}}
    end
  end)

  case result do
    {:halt, res} -> {:halt, res}
    other -> {:cont, other}
  end
end)
|> IO.inspect(label: "Part 2")