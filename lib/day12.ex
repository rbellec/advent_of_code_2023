defmodule Day12 do
  defmodule Parser do
    import Enum

    def parse(input) do
      lines =
        input
        |> String.split("\n", trim: true)
        |> with_index
        |> parse_line()
    end

    def parse_line({line, line_index}) do
      [springs, groups] = line |> String.split(" ")

      springs_conditions =
        String.graphemes(springs)

      # |> map(fn
      #   "#" -> :damaged
      #   "." -> :operational
      #   "?" -> :unknown
      # end)

      spring_groups =
        String.split(groups, ",")
        |> map(&String.to_integer/1)

      %{line: line, line_index: line_index, conditions: springs_conditions, groups: spring_groups}
    end
  end

  defmodule Part1 do
    @possibly_damaged ["?", "#"]

    # Take the line and a group size. for each char on the line, return the number of possibiles positions of a group of this size in the string
    # from this position.
    def possible_placements_from_position(line, group_size) do
      # Reduce on a reversed list to work to stay in linear time.
      Enum.reverse(line)
      |> Enum.reduce({0, []}, fn position_value, {successives, previous_counts} ->
        # IO.puts(inspect({successives, previous_counts}))
        previous_placement_counts =
          case previous_counts do
            [] -> 0
            [a | _] -> a
          end

        case {position_value, successives} do
          {e, s} when e in @possibly_damaged and s >= group_size - 1 ->
            {group_size, [1 + previous_placement_counts | previous_counts]}

          {e, s} when e in @possibly_damaged ->
            {s + 1, [previous_placement_counts | previous_counts]}

          _ ->
            {0, [previous_placement_counts | previous_counts]}
        end
      end)
      |> elem(1)
    end

    # def possible_positions(line, group_size) do
    #   Enum.reduce(line, {0, []}, fn position_value, {successives, possible_positions} ->
    #     IO.puts(inspect({successives, possible_positions}))

    #     case {position_value, successives} do
    #       {e, s} when e in @possibly_damaged and s >= group_size - 1 ->
    #         {group_size, [position_value - s | possible_positions]}

    #       {e, s} when e in @possibly_damaged ->
    #         {s + 1, possible_positions}

    #       _ ->
    #         {0, possible_positions}
    #     end
    #   end)
    #   |> elem(1)
    # end
  end
end
