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

  defp get_repeated_item({a, b} = _), do: get_repeated_item(String.graphemes(a), [String.graphemes(b)])
  defp get_repeated_item([a | tail] = _), do: get_repeated_item(String.graphemes(a), Enum.map(tail, &String.graphemes/1))

  defp get_repeated_item([l | tail], second) do
    is_duplicated = second
    |> Enum.map(&Enum.member?(&1, l))
    |> Enum.all?(&(&1 == true))

    if(is_duplicated) do
      l
    else
      get_repeated_item(tail, second)
    end
  end

  defp split_rucksack(rucksack) do
    item_count = div(String.length(rucksack), 2)
    String.split_at(rucksack, item_count)
  end

  defp calculate_priority(letter) do
    ascii = to_ascii(letter)

    cond do
      ascii >= 97 -> ascii -  96
      true -> ascii - 38
    end
  end

  defp to_ascii(string) when is_binary(string), do: :binary.first(string)

  defp get_rucksacks() do
    AdventOfCode.Input.get!(3, 2022)
    |> String.trim()
    |> String.split("\n")
  end
end
