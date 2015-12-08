defmodule Arc do
  defstruct first: %Point{ x: 0, y: 0}, second: %Point{ x: 0, y: 0 }
end

defmodule Fortune do

  def main(_) do
    :random.seed(:erlang.now)
    rect = %Rect{
      size: %Size{height: 500, width: 500},
      origin: %Point{ x: 0, y: 0}
    }

    random_points = RandomPoints.generate_random_points(rect, 50)

    queue = Enum.reduce random_points, EventQueue.new(), fn point, acc ->
      EventQueue.push(acc, rect.size.height - point.y, point)
    end

    sweep(rect, EventQueue.pop(queue), [], Drawing.create_base_canvas(rect, random_points), 1)
  end

  def sweep(rect, {:empty, _}, beachline, canvas, _) do
    IO.puts "done"
  end


  def sweep(rect, {{:value, priority, site}, queue}, beachline, canvas, current_frame) do

    [ index: index, arc: arc ] = Beachline.find_arc(beachline, site)

    cond do
      index > 0 and index < Enum.count(beachline) ->
        old_triple = [Enum.at(beachline, index-1), arc, Enum.at(beachline, index+1)]
        queue = EventQueue.remove(queue, old_triple)
      true ->
    end

    [ beachline: beachline, indicies: indicies] = Beachline.insert(beachline, index, site)

    generate_vertext_events(queue, beachline, indicies, site.y)

    Drawing.draw_frame(canvas, rect.size.width, site.y, beachline, current_frame)

    sweep(rect, EventQueue.pop(queue), beachline, canvas, current_frame+1)
  end

  def generate_vertext_events(queue, beachline, indicies, sweep_line_y) do
    { queue, beachline } = generate_vertext_event(queue, beachline, indicies[0], sweep_line_y)
    generate_vertext_event(queue, beachline, indicies[2], sweep_line_y)
  end

  def generate_vertext_event(queue, beachline, midarc_index, sweep_line_y) do
    cond do
      midarc_index > 0 and midarc_index < Enum.count(beachline) ->
        a = beachline[midarc_index-1]
        b = beachline[midarc_index]
        c = beachline[midarc_index+1]

        handle_circle_midpoint(queue, beachline, Geometry.circle(a, b, c), [a, b, c], sweep_line_y)
      true -> { queue, beachline }
    end

  end

  defp handle_circle_midpoint(queue, beachline, false, _, _) do
    { queue, beachline }
  end

  defp handle_circle_midpoint(queue, beachline, midpoint, triple, sweep_line_y) do
    radius = Geometry.distance(midpoint, triple[0])

    cond do
      midpoint.y - radius < sweep_line_y ->
        EventQueue.push(queue, sweep_line_y, triple)
      true -> { queue, beachline }
    end
  end

end
