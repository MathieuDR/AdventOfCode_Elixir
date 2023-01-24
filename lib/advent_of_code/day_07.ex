defmodule AdventOfCode.Day07 do
  def part1(_args) do
    get_commands_strings()
    |> parse_commands()
    |> create_structure()
  end

  def part2(_args) do
  end

  def parse_command("$ cd .." <> _ = _), do: {:cd, :parent_dir}
  def parse_command("$ cd " <> dir = _), do: {:cd, dir}
  def parse_command("$ ls" <> _ = _), do: {:ls, nil}
  def parse_command( "dir " <> dir = _), do: {:dir, dir}
  def parse_command(file_info) when is_binary(file_info) do
    [size, file] = String.split(file_info, " ")
    {:file, {file, size}}
  end

  def get_commands_strings(), do:  AdventOfCode.Input.get!(7, 2022)

  def parse_commands(command_strings) do
    command_strings
    |> String.trim()
    |> String.split("\n")
    |> Enum.take(20)
    |> Enum.map(&parse_command/1)
  end

  def create_structure(commands) when is_list(commands) do
    commands = Enum.slice(commands, 1..-1)

    create_structure(commands, "/", %{"/" => create_new_dir(nil)})
  end
  def create_structure([{:cd, :parent_dir} | tail ], current_dir_key, dir_map) do
    # IO.inspect(current_dir_key, label: "current")
    # IO.inspect(dir_map, label: "structure")

    create_structure(tail, Map.fetch!(dir_map, current_dir_key).parent, dir_map)
  end
  def create_structure([{:cd, dir} | tail ], current_dir_key, dir_map) do
    compound = get_compound_key(current_dir_key, dir_map)
    |> IO.inspect(label: "compound: ")

    # compound = get_compound_key(Map.fetch!(dir_map, current_dir_key), dir_map, dir)
    # |> IO.inspect(label: "compound: ")
    create_structure(tail, compound, dir_map)
    # compound = get_compound_key(Map.fetch!(dir_map, current_dir_key), dir_map, dir)
    # |> IO.inspect(label: "compound: ")

    # check_if_exists(compound, dir_map)

    # structure = dir_map
    # |> Map.put(compound, create_new_dir(current_dir_key))

    # create_structure(tail, compound, structure)
  end

  def create_structure([{:dir, dir} | tail ], current_dir_key, dir_map) do
    # IO.inspect(current_dir_key, label: "key in dir: ")

    current = Map.fetch!(dir_map, current_dir_key)
    |> IO.inspect(label: "current")

    # compound = get_compound_key(Map.fetch!(dir_map, current_dir_key), dir_map, current_dir_key)
    # |> IO.inspect(label: "compound: ")

    compound = get_compound_key(current_dir_key, dir_map)
    |> IO.inspect(label: "compound: ")

    # check_if_exists(compound, dir_map)

    # adds new dir
    dir_map = dir_map
    |> Map.put_new(compound, create_new_dir(current_dir_key))
    # |> IO.inspect(label: "structure: ")


    # adds to list
    # current = dir_map
    # |> Map.fetch!(current_dir_key)

    current = Map.replace!(current, :dirs, [ dir | current.dirs ])
    dir_map = Map.replace!(dir_map, current_dir_key, current)

    create_structure(tail, current_dir_key, dir_map)
  end

  def create_structure([{:file, file} | tail ], current_dir_key, dir_map) do
    # IO.inspect(current_dir_key, label: "key: ")

    current = dir_map
    |> Map.fetch!(current_dir_key)

    current = Map.replace!(current, :files, [ file | current.files ])
    dir_map = Map.replace!(dir_map, current_dir_key, current)
    create_structure(tail, current_dir_key, dir_map)
  end

  def create_structure([{:ls, _} | tail ], current_dir_key, dir_map), do: create_structure(tail, current_dir_key, dir_map)
  def create_structure([], _, dir_map), do: dir_map

  def create_new_dir(parent), do: %{parent: parent, files: [], dirs: []}

  def check_if_exists(key, map) do
    val = map
    |> Map.fetch(key)

    case val do
      {:ok, _} -> raise "dir #{key} found"
      _ -> nil
    end
  end

  # def get_compound_key(nil, _, compound_key), do: compound_key
  def get_compound_key(%{parent: nil}, _, compound_key), do: compound_key
  def get_compound_key(%{parent: key}, dir_map, compound_key), do: get_compound_key(Map.fetch!(dir_map, key), dir_map, add_dir_to_directory(compound_key, key))
  def get_compound_key("/", _), do: "/"
  def get_compound_key(current_dir_key, dir_map), do: get_compound_key(Map.fetch!(dir_map, current_dir_key), dir_map, current_dir_key)

  def add_dir_to_directory(dir, directory), do: directory <> "/" <> dir


end
