defmodule Day13 do
  import Enum

  # 0 for part 1, 1 for part 2
  # @allowed_differences 1

  # Finally using part as a module constant. Count the number of differences between two rows/lines.
  def differences(a, b) do
    zip(map([a, b], &String.graphemes/1))
    |> count(fn {i, j} -> i != j end)
  end

  # I now am 4 day late, so I'll definitely go to the simplest
  def parse(input) do
    String.split(input, "\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
  end

  # Take a list of string and return the transposed version as a list of string.
  def transpose(lines) do
    lines
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip_with(&Function.identity/1)
    |> Enum.map(&List.to_string/1)
  end

  def find_successive_identic_lines(mirror_field, allowed_differences) do
    Enum.zip(mirror_field, tl(mirror_field))
    # {{row 0, row 1}, index of row 0}
    |> Enum.with_index()
    # |> Enum.filter(fn {{r0, r1}, _} -> r0 == r1 end)
    |> Enum.filter(fn {{r0, r1}, _} -> differences(r0, r1) <= allowed_differences end)
    |> Enum.map(&elem(&1, 1))
  end

  def check_reflexion(mirror_field, allowed_differences, index) do
    {left, right} = Enum.split(mirror_field, index + 1)

    differences =
      zip(Enum.reverse(left), right)
      |> map(fn {l, r} -> differences(l, r) end)
      |> sum()

    differences == allowed_differences
  end

  def find_reflexions(mirror_field, allowed_differences) do
    # Get indices of every 2 successive identic lines then check all lines arounds are identics
    mirror_field
    |> find_successive_identic_lines(allowed_differences)
    |> Enum.filter(&check_reflexion(mirror_field, allowed_differences, &1))
  end

  def solve(input, part) do
    allowed_differences =
      case part do
        1 -> 0
        2 -> 1
      end

    mirror_fields = parse(input)
    transposed_mirror_files = Enum.map(mirror_fields, &transpose/1)

    horizontal_reflexions =
      Enum.flat_map(mirror_fields, &find_reflexions(&1, allowed_differences))

    vertical_reflexions =
      Enum.flat_map(transposed_mirror_files, &find_reflexions(&1, allowed_differences))

    h_score = horizontal_reflexions |> map(&((&1 + 1) * 100)) |> sum
    v_score = vertical_reflexions |> map(&(&1 + 1)) |> sum

    # require IEx; IEx.pry()
    h_score + v_score
  end
end

defmodule Mix.Tasks.Day13 do
  use Mix.Task

  def run(_) do
    input_filename = "inputs/day13.txt"
    {:ok, input} = File.read(input_filename)

    IO.puts("--- Part 1 --- : change allowed differences to 0")
    IO.puts(to_string(Day13.solve(input, 1)))

    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(to_string(Day13.solve(input, 2)))
  end
end
