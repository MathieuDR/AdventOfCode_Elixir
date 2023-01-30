defmodule AdventOfCode.Day07 do
  def part1(_args) do
    get_commands_strings()
    |> parse_commands()
    |> do_commands()
  end

  def part2(_args) do
  end

  def parse_command("$ cd .." <> _ = _), do: {:cd, :parent_dir}
  def parse_command("$ cd " <> dir = _), do: {:cd, dir}
  def parse_command("$ ls" <> _ = _), do: {:ls, nil}
  def parse_command("dir " <> dir = _), do: {:dir, dir}

  def parse_command(file_info) when is_binary(file_info) do
    [size, file] = String.split(file_info, " ")
    {:file, {file, size}}
  end

  def get_commands_strings(), do: AdventOfCode.Input.get!(7, 2022)

  def parse_commands(command_strings) do
    command_strings
    |> String.trim()
    |> String.split("\n")
    # |> Enum.take(20)
    |> Enum.map(&parse_command/1)
  end

  def do_commands(commands) when is_list(commands) do
    commands = Enum.slice(commands, 1..-1)

    do_commands(commands, ["/"], %{"/" => create_new_dir(nil)})
  end

  def do_commands([{:cd, :parent_dir} | tail], [_ | path], dir_map) do
    do_commands(tail, path, dir_map)
  end

  def do_commands([{:cd, dir} | tail], current_path, dir_map), do: do_commands(tail, [dir | current_path], dir_map)


  def do_commands([{:dir, dir} | tail], current_path, dir_map) do
    case add_item(dir, dir_map, :dirs, current_path) do
      {:noop, map} -> do_commands(tail, current_path, map)
      {:ok, map} -> do_commands(tail, current_path, add_new_dir(dir, current_path, map))
    end
  end

  def do_commands([{:file, file} | tail], current_path, dir_map) do
    {_, map} = add_item(file, dir_map, :files, current_path)
    do_commands(tail, current_path, map)
  end

  def do_commands([{:ls, _} | tail], current_path, dir_map), do: do_commands(tail, current_path, dir_map)

  def do_commands([], _, dir_map), do: dir_map

  def add_new_dir(dir, path, map) do
    to_add = create_new_dir(path)
    |> IO.inspect(label: dir)

    parent = get_in_reverse(map, path)
    |> Map.put_new(dir, to_add)

    put_in_reverse(map, path, parent)
  end

  def exist(map, key, item) do
    map
    |> Map.fetch!(key)
    |> Enum.member?(item)
  end

  def add_item(item, map, item_key, path) do
    current = get_in_reverse(map, path)
    |> IO.inspect(label: path)

    if exist(current, item_key, item) do
      IO.puts("We exist!")
      {:noop, map}
    else
      new_map = Map.replace!(current, item_key, [item | Map.fetch!(current, item_key)])
      result = put_in_reverse(map, path, new_map)
      {:ok, result}
    end
  end

  def get_in_reverse(map, path), do: get_in(map, Enum.reverse(path))
  def put_in_reverse(map, path, value), do: put_in(map, Enum.reverse(path), value)

  def create_new_dir(parent), do: %{parent: parent, files: [], dirs: []}

  def check_if_exists(key, map) do
    val =
      map
      |> Map.fetch(key)

    case val do
      {:ok, _} -> raise "dir #{key} found"
      _ -> nil
    end
  end
end
