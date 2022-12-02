defmodule AdventOfCode.Day01 do
  def part1(_args) do
    create_elves()
    |> Enum.max()
  end

  def part2(_args) do
    create_elves()
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end

  def create_elves() do
    AdventOfCode.Input.get!(1, 2022)
    |> String.trim()
    |> String.split(~r{(\r\n\r\n|\n\n)}) # Split in chunks for separate elves
    |> Enum.map(&calculate_carried_calories(&1))
  end

  defp calculate_carried_calories(list) do
    list
    |> String.split(~r{(\r\n|\n)})
    |> Enum.map(&String.to_integer(&1))
    |> Enum.sum()
  end
end
