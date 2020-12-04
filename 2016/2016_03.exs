File.read!("2016_03.in")
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  line
  |> String.trim()
  |> String.split(" ")
  |> Enum.reject(fn v -> v == "" end)
  |> Enum.map(&String.to_integer/1)
end)
|> Enum.map(fn [x, y, z] ->
  if (x + y) > z && (x + z) > y && (y + z) > x do
    1
  else
    0
  end
end)
|> Enum.sum()
|> IO.inspect(label: "First")



File.read!("2016_03.in")
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  line
  |> String.trim()
  |> String.split(" ")
  |> Enum.reject(fn v -> v == "" end)
  |> Enum.map(&String.to_integer/1)
end)
|> Enum.chunk_every(3)
|> Enum.map(fn three_rows ->
  three_rows
  |> Enum.zip()
  |> Enum.map(fn {x, y, z} ->
    if (x + y) > z && (x + z) > y && (y + z) > x do
      1
    else
      0
    end
  end)
  |> Enum.sum()
end)
|> Enum.sum()
|> IO.inspect(label: "Second")