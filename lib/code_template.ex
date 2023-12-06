defmodule Day0 do
  defmodule Parser do
    def parse(input) do
      input
    end
  end

  defmodule Part1 do
    def solve(input) do
      Parser.parse(input)

      # ...
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

defmodule Mix.Tasks.Day0 do
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
