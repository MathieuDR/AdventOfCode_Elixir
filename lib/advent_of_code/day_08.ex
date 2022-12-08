defmodule AdventOfCode.Day08 do
  def part1(_args) do
    trees = get_trees()

    trees
    |> Enum.map(fn({row, tree_row})->
       tree_row
       |> Enum.map(fn({column, _}) ->
           calculate_visibility(trees, row, column)
           |> Enum.map(fn {v, _} = _ -> v end)
           |> Enum.any?(& &1)
       end)
       |> Enum.reduce(0, fn(v, acc) ->
          if v, do: acc + 1, else: acc
       end)
    end)
    |> Enum.sum()
  end

  def part2(_args) do
    trees = get_trees()

    trees
    |> Enum.map(fn({row, tree_row})->
       tree_row
       |> Enum.map(fn({column, _}) ->
           calculate_visibility(trees, row, column)
           |> Enum.reduce(1, fn ({_, a} = _, acc) -> if a == 0, do: acc, else: acc * a end)
       end)
       |> Enum.max()
    end)
    |> Enum.max()
  end

  def calculate_visibility(trees, row, column) do
    height = get_height(trees, row, column)

    traverse_adjacent(row, column, fn (d, c) ->
      check_visible(trees,height, d, c )
    end)
  end

  def traverse_adjacent(y, x, fun) do
    [fun.({1, 0}, {y, x}), fun.({0, 1}, {y, x}), fun.({-1, 0}, {y, x}), fun.({0, -1}, {y, x})]
  end

  # Visible if everything is SHORTER. can return false when it's higher
  def check_visible(trees, height, {x_delta, y_delta} = delta, {y, x} = _, visible_trees \\ 0) do
    new_y = y + y_delta
    new_x = x + x_delta
    new_coord = {new_y, new_x}

    tree_to_check = get_height(trees, new_y, new_x)

    cond do
      tree_to_check == -1 -> { true, visible_trees}
      tree_to_check >= height -> { false, visible_trees + 1}
      true -> check_visible(trees, height, delta, new_coord, visible_trees + 1)
    end
  end

  def get_height(trees, row, column), do: if is_nil(trees[row][column]), do: -1, else: trees[row][column]

  def get_trees() do
    AdventOfCode.Input.get!(8, 2022)
    |> String.trim()
    |> String.split("\n")
    # |> Enum.take(5)
    |> Enum.map(fn row ->
      row
      |> String.graphemes()
      # |> Enum.take(5)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Map.new(fn {v, k} -> {k, v} end)
    end)
    |> Enum.with_index()
    |> Map.new(fn {v, k} -> {k, v} end)
  end
end
