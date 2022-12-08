defmodule AdventOfCode.Day06 do
  def part1(_args) do
    get_data_stream()
    |> IO.inspect()
    |> search_first_packet(4)
  end

  def part2(_args) do
    get_data_stream()
    |> IO.inspect()
    |> search_first_packet(14)
  end

  def search_first_packet([_ | tail] = stream, amount, counter \\ 0) do
    {split, _} = Enum.split(stream, amount)

    if check_repeating(split) do
      search_first_packet(tail, amount, counter + 1)
    else
      counter + amount
    end
  end


  def check_repeating([] = _), do: false
  def check_repeating([c | tail] = _) do
    if Enum.member?(tail, c), do: true, else: check_repeating(tail)
  end

  def get_data_stream() do
    AdventOfCode.Input.get!(6, 2022)
    |> String.trim()
    |> String.to_charlist()
  end
end
