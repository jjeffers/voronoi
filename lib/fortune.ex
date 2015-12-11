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

  def sweep(rect, {{:value, priority, [arc_a, arc_b, arc_c]}, queue}, beachline, canvas, current_frame) do
    IO.puts "vertex event priority #{priority}, removing arc:"
    IO.inspect arc_b

    [ index: index, arc: arc ] = Beachline.find_arc(beachline, arc_b)

    beachline = Beachline.delete(beachline, arc)
    queue = EventQueue.remove_with_arc(queue, arc)
    queue = generate_vertex_events(rect, queue, beachline, [index-1,nil,index], priority)

    sweep(rect, EventQueue.pop(queue), beachline, canvas, current_frame)
  end


  def sweep(rect, {{:value, priority, site}, queue}, beachline, canvas, current_frame) do

    IO.puts "site event #{current_frame} - priority #{priority}"

    [ index: index, arc: arc ] = Beachline.find_arc(beachline, site, site.y)

    cond do
      index > 0 and index < Enum.count(beachline) ->
        old_triple = [Enum.at(beachline, index-1), arc, Enum.at(beachline, index+1)]
        queue = EventQueue.remove(queue, old_triple)
      true ->
    end

    #IO.puts "\tinserting site (#{site.x}, #{site.y}) into beachline"
    [ beachline: new_beachline, indicies: indicies] = Beachline.insert(beachline, index, site)

    queue = generate_vertex_events(rect, queue, new_beachline, indicies, site.y)

    Drawing.draw_frame(canvas, rect.size.width, site.y, new_beachline, current_frame)

    sweep(rect, EventQueue.pop(queue), new_beachline, canvas, current_frame+1)
  end

  def generate_vertex_events(rect, queue, beachline, indicies, sweep_line_y) do
    queue = generate_vertex_event(rect, queue, beachline, Enum.at(indicies, 0), sweep_line_y)
    generate_vertex_event(rect, queue, beachline, Enum.at(indicies, 2), sweep_line_y)
  end

  def generate_vertex_event(rect, queue, beachline, midarc_index, sweep_line_y) do

    cond do
      midarc_index > 1 and midarc_index < Enum.count(beachline)-1 ->

        a = Enum.at(beachline, midarc_index-1)
        b = Enum.at(beachline, midarc_index)
        c = Enum.at(beachline, midarc_index+1)

        handle_circle_midpoint(rect, queue, Geometry.circle(a, b, c), [a, b, c], sweep_line_y)
      true -> queue
    end

  end

  defp handle_circle_midpoint(_, queue, false, _, _) do
    queue
  end

  defp handle_circle_midpoint(rect, queue, midpoint, triple, sweep_line_y) do
    radius = Geometry.distance(midpoint, Enum.at(triple,0))

    cond do
      midpoint.y - radius < sweep_line_y ->
        EventQueue.push(queue, rect.size.height - (midpoint.y - radius), triple)
      true -> queue
    end
  end

end
