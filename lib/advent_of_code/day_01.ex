defmodule AdventOfCode.Day01 do
  def part1(_args) do
    AdventOfCode.Input.get!(1, 2022)
     |> String.split(~r{(\r\n|\r|\n)})
     |> Enum.map(fn i -> Integer.parse(i) end)
     |> createCaloriesPerElfList()
     |> Enum.max()
  end

  def part2(_args) do
    AdventOfCode.Input.get!(1, 2022)
     |> String.split(~r{(\r\n|\r|\n)})
     |> Enum.map(fn i -> Integer.parse(i) end)
     |> createCaloriesPerElfList()
     |> Enum.sort()
     |> Enum.take(-3)
     |> Enum.sum()
  end

  defp createCaloriesPerElfList(items), do: createCaloriesList(items, 0, [])
  defp createCaloriesList([], currentWeight, weightPerElf), do: [currentWeight | weightPerElf]
  defp createCaloriesList( [{res, _} | tail] = _, currentElfWeight, weightPerElf), do: createCaloriesList(tail, currentElfWeight + res, weightPerElf)
  defp createCaloriesList( [:error | tail] = _, currentElfWeight, weightPerElf), do: createCaloriesList(tail, 0, [currentElfWeight | weightPerElf])
end
