defmodule AdventOfCode.Day05 do
  def part1(_args) do
    {stacks, moves} = get_planning()

    # IO.inspect(stacks)

    moves
    |> Enum.reduce(stacks, fn  (%{crates: amount, from: a, to: b} = map, acc) ->
      IO.inspect(map)

       move_crate(acc, amount, a, b)
       |> IO.inspect()
    end)
  end

  def part2(_args) do
  end

  def move_crate(crates, amount, from, to) do
    from_stack = Enum.at(crates, from - 1)
    to_stack = Enum.at(crates, to - 1)

    {taken, new_from_stack} = remove_x_crates(from_stack, amount)
    new_to_stack = append_to_stack(to_stack, taken)

    crates
    |> List.replace_at(from - 1, new_from_stack)
    |> List.replace_at(to - 1, new_to_stack)

    # crates
    # |> Enum.map(fn
    #   ^from_stack = _ -> new_from_stack
    #   ^to_stack = _ -> new_to_stack
    #   s -> s
    # end)
  end

  def append_to_stack(crates, [_|_] = stack), do: stack ++ crates
  def append_to_stack(crates, single), do: [single | crates]

  def remove_x_crates(crate_stack, x) do
    {removed, tail} = crate_stack
    |> Enum.split(x)

    {Enum.reverse(removed), tail}
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
