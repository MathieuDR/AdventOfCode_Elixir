defmodule AdventOfCode.Day03 do
  def part1(_args) do
    get_rucksacks()
    |> Enum.map(&split_rucksack/1)
    |> calculate_priority_sum()
  end

  def part2(_args) do
    get_rucksacks()
    |> Enum.chunk_every(3)
    |> calculate_priority_sum()
  end

  defp calculate_priority_sum(items) do
    items
    |> Enum.reduce(0, fn item_list, acc ->
      priority = item_list
      |> get_repeated_item()
      |> calculate_priority()

      priority + acc
    end)
  end

  def get_repeated_item(items) do
    items
    |> Enum.map(&(MapSet.new(to_charlist(&1))))
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.to_list()
  end

  defp split_rucksack(rucksack) do
    item_count = div(String.length(rucksack), 2)
    {a, b} = String.split_at(rucksack, item_count)
    [a, b]
  end

  def calculate_priority([letter | _] = _), do: calculate_priority(letter)

  def calculate_priority(letter) do
    cond do
      letter in ?a..?z -> letter - ?a + 1
      letter in ?A..?Z -> letter - ?A + 27
    end
  end

  defp get_rucksacks() do
    AdventOfCode.Input.get!(3, 2022)
    |> String.trim()
    |> String.split("\n")
  end
end
