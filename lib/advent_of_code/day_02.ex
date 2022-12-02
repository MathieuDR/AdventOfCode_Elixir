defmodule AdventOfCode.Day02 do
  def part1(_args) do
    get_match_lines()
    |> Enum.map(&score_match/1)
    |> Enum.sum()
  end

  def part2(_args) do
    get_match_lines()
    |> Enum.map(&decide_and_score_match/1)
    |> Enum.sum()
  end

  def decide_and_score_match(line) do
    [opponent, match] = line
    |> String.split(" ")

    opponent_shape = score_shape(opponent)
    match_result = score_result(match)

    get_shape_score(match_result, opponent_shape) + match_result

  end

  def get_shape_score(match_result, opponent_shape) do
    case match_result do
      0 -> opponent_shape - 1
      3 -> opponent_shape
      6 -> opponent_shape + 1
    end
    |> keep_shape_in_bound()
  end

  def keep_shape_in_bound(0), do: 3
  def keep_shape_in_bound(4), do: 1
  def keep_shape_in_bound(shape), do: shape

  def score_match(line) do
    [p1, p2] = line
    |> String.split(" ")
    |> Enum.map(&score_shape/1)

    p2 + score_result(p1, p2)
  end

  defp get_match_lines do
    AdventOfCode.Input.get!(2, 2022)
    |> String.trim()
    |> String.split("\n")
  end

  defp score_result("X"), do: 0
  defp score_result("Y"), do: 3
  defp score_result("Z"), do: 6

  defp score_shape("Y"), do: 2
  defp score_shape("X"), do: 1
  defp score_shape("Z"), do: 3
  defp score_shape("A"), do: 1
  defp score_shape("B"), do: 2
  defp score_shape("C"), do: 3

  defp score_result(1, 3), do: 0
  defp score_result(3, 1), do: 6
  defp score_result(p1, p2) when p1 == p2,  do: 3
  defp score_result(p1, p2) when p1 > p2,  do: 0
  defp score_result(p1, p2) when p1 < p2,  do: 6
end
