defmodule AdventOfCode.Day04 do
  def part1(_args) do
    get_elves_ranges()
    |> Enum.map(&Enum.map(&1, fn r -> create_range(r) end))
    |> Enum.map(&has_overlap?/1)
    |> Enum.reduce(0, fn overlap, acc -> if overlap do acc + 1 else acc end end)
  end

  def part2(_args) do
  end

  def has_overlap?([r1_min..r1_max, r2_min..r2_max] = _) when r1_min <= r2_min and r1_max >= r2_max, do: true
  def has_overlap?([r1_min..r1_max, r2_min..r2_max] = _) when r1_min >= r2_min and r1_max <= r2_max, do: true
  def has_overlap?(_) , do: false

  def create_range(range) do
    [a, b] = String.split(range, "-")
    |> Enum.map(&String.to_integer/1)

    a..b
  end

  defp get_elves_ranges() do
    AdventOfCode.Input.get!(4, 2022)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
  end
end
