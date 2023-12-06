defmodule Day06 do
  defmodule Parser do
    import Enum

    def parse(input) do
      lists =
        String.split(input, "\n", trim: true)
        |> map(fn line ->
          Regex.scan(~r/\d+/, line) |> map(&String.to_integer(hd(&1)))
        end)

      [times, distances] = lists
      zip(times, distances)
    end
  end

  defmodule Part1 do
    import Enum

    def solve(input) do
      Parser.parse(input)

      # ...
    end

    def solve_race({time, distance}) do
      delta = time ** 2 - 4 * distance

      cond do
        # No solution for this race.
        delta < 0 ->
          nil

        # Only one solution.
        delta == 0 ->
          1

        true ->
          solutions = [(-time - :math.sqrt(delta)) / 2, (-time + :math.sqrt(delta)) / 2]
          trunc(max(solutions) - min(solutions)) + 1
      end
    end
  end

  defmodule Part2 do
    # def solve(input) do
    #   input
    #   |> Day0.Part1.parse_input()

    #   # ...
    # end
  end
end

defmodule Mix.Tasks.Day06 do
  use Mix.Task

  @spec run(any()) :: :ok
  def run(_) do
    input_filename = "inputs/day00.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 ---")
    IO.puts(Day0.Part1.solve(input))
    IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day0.Part2.solve(input))
  end
end
