defmodule Stuff do

  @max_x 50-1
  @max_y 6-1

  def handle("rect "<> x <>"x"<> y, display) do
    x = String.to_integer(x) - 1
    y = String.to_integer(y) - 1

    Enum.reduce(0..x, display, fn xx, agg ->
      Enum.reduce(0..y, agg, fn yy, agg ->
        Map.put(agg, {xx, yy}, 1)
      end)
    end)
  end

  def handle("rotate row y="<> y <>" by " <> by, display) do
    by = String.to_integer(by)
    y = String.to_integer(y)

    Enum.reduce(0..@max_x, display, fn pos_x, agg ->
      prev_pos = pos_x - by
      prev_pos = if prev_pos < 0, do: prev_pos + @max_x, else: prev_pos

      prev_val = Map.get(display, {prev_pos, y})
      Map.put(agg, {pos_x, y}, prev_val)
    end)
  end

  def handle("rotate column x="<> x <>" by "<> by, display) do
    by = String.to_integer(by)
    x = String.to_integer(x)

    Enum.reduce(0..@max_y, display, fn pos_y, agg ->
      prev_pos = pos_y - by
      prev_pos = if prev_pos < 0, do: prev_pos + @max_y, else: prev_pos

      prev_val = Map.get(display, {x, prev_pos})
      Map.put(agg, {x, pos_y}, prev_val)
    end)
  end
end


"2016_07.in"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.reduce(%{}, fn line, acc ->
  Stuff.handle(line, acc)
end)
|> Enum.count(fn {_coord, val} -> val == 1 end)
|> IO.inspect(label: "Part 1")