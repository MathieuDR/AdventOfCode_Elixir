defmodule AdventOfCode.Day05 do
  def part1(_args) do
    solve()
  end

  def part2(_args) do
    solve(false)
  end

  def solve(reverse \\ true) do
    {stacks, moves} = get_planning()

    moves
    |> Enum.reduce(stacks, fn  (%{crates: amount, from: a, to: b} = _, acc) ->
       move_crate(acc, amount, a, b, reverse)
    end)
    |> Enum.reduce('', fn (element,acc) ->  append_to_stack(acc, Enum.at(element, 0)) end)
    |> Enum.reverse()
  end

  def move_crate(crates, amount, from, to, reverse) do
    from_stack = Enum.at(crates, from - 1)
    to_stack = Enum.at(crates, to - 1)

    {taken, new_from_stack} = remove_x_crates(from_stack, amount, reverse)
    new_to_stack = append_to_stack(to_stack, taken)

    crates
    |> List.replace_at(from - 1, new_from_stack)
    |> List.replace_at(to - 1, new_to_stack)
  end

  def append_to_stack(crates, [_|_] = stack), do: stack ++ crates
  def append_to_stack(crates, single), do: [single | crates]

  def remove_x_crates(crate_stack, x, reverse) do
    {removed, tail} = crate_stack
    |> Enum.split(x)

    removed = if reverse, do: Enum.reverse(removed), else: removed
    {removed, tail}
  end

  def get_planning() do
    [stacks, moves] = AdventOfCode.Input.get!(5, 2022)
    |> String.split("\n\n")

    parsed_stacks = parse_stacks(stacks)
    parsed_moves = parse_moves(moves)

    {parsed_stacks, parsed_moves}
  end

  def parse_moves(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, amount, _, a, _, b | _] = String.split(line, " ")
      %{crates: String.to_integer(amount), from: String.to_integer(a), to: String.to_integer(b)}
    end)
  end

  def parse_stacks(input) do
    input
    |> String.split("\n")
    |> Enum.drop(-1)
    |> Enum.map(fn crateLine ->
        String.to_charlist(crateLine)
       |> Enum.chunk_every(4)
       |> Enum.map(fn
          [?[, n, ?] | _] -> n
          _ -> nil
        end)
    end)
    |> Enum.zip_with(& &1)
    |> Enum.map(fn elem -> Enum.filter(elem, &!is_nil(&1)) end)
  end
end
