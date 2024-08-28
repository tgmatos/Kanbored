list = [1, 2, nil, 3, 4, 5, nil, nil, 6, 7, 8, 9, nil, 0]

list
|> Enum.reduce([], fn x, acc ->
  if x == nil do
    IO.inspect(acc)
    acc
  end

  [x | acc]
end)
