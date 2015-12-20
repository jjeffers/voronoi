defmodule Arc do
  defstruct first: %Point{ x: 0, y: 0}, second: %Point{ x: 0, y: 0 }
end

defmodule Fortune do

  def main(_) do
    rect = %Rect{
      size: %Size{height: 110, width: 110},
      origin: %Point{ x: 0, y: 0}
    }


    points = [
      %Point{ x: 0, y: 0},
      %Point{ x: 0, y: 100},
      %Point{ x: 20, y: 50},
      %Point{ x: 30, y: 60},
      %Point{ x: 40, y: 50},
      %Point{ x: 60, y: 30},
      %Point{ x: 60, y: 50},
      %Point{ x: 100, y: 0},
      %Point{ x: 100, y: 100},
    ]

    diagram = fortune(rect, Enum.sort(points, &(&1.y > &2.y)))
    IO.puts "Voronoi vertices: (#{Enum.count(diagram)})"
    IO.inspect diagram
  end

  def random_start do
    :random.seed(:erlang.now)
    rect = %Rect{
      size: %Size{height: 100, width: 100},
      origin: %Point{ x: 0, y: 0}
    }

    random_points = RandomPoints.generate_random_points(rect, 5)

    fortune(rect, random_points)
    #Drawing.draw_voronoi_diagram(canvas, voronoi_diagram)

  end

  def fortune(rect, points) do
    queue = Enum.reduce points, EventQueue.new(), fn point, acc ->
      EventQueue.push(acc, rect.size.height - point.y, point)
    end

    sweep(rect, EventQueue.pop(queue), [], [], [])
  end

  def sweep(rect, {:empty, _}, beachline, voronoi_vertices, voronoi_edges) do
    %{ vertices: voronoi_vertices, edges: voronoi_edges }
  end

  def sweep(rect, {{:value, priority, [arc_a, arc_b, arc_c]}, queue}, beachline,
    voronoi_vertices, voronoi_edges) do

    IO.puts "\nvertex event priority #{priority}, removing arc:"
    IO.inspect arc_b

    [ index: index, arc: arc ] = Beachline.find_arc(beachline, arc_b)
    IO.puts "index of arc: #{index}"

    IO.puts "removing this arc from beachline, before"
    IO.inspect beachline
    beachline = Beachline.delete(beachline, arc)
    IO.puts "removing this arc from beachline, after"
    IO.inspect beachline

    IO.puts "removing any events using this arc, before"
    IO.inspect queue
    queue = EventQueue.remove_with_arc(queue, arc)
    IO.puts "removing any events using this arc, after"
    IO.inspect queue

    # remove old triples [arc_X, arc_a, arc_b] and [arc_b, arc_c, arc_Y] here!
    if index > 1 do
      IO.puts "REMOVING OLD TRIPLES left"
      queue = EventQueue.remove(queue, [Enum.at(beachline, index-2), Enum.at(beachline, index-1), arc_b])
    end

    if index < Enum.count(beachline)-1 do
      IO.puts "REMOVING OLD TRIPLES right"
      IO.inspect [arc_b, Enum.at(beachline, index+1),
        Enum.at(beachline, index+2)]
      IO.puts "removing any events before"
      IO.inspect queue

      queue = EventQueue.remove(queue, [arc_b, Enum.at(beachline, index+1),
        Enum.at(beachline, index+2)])
        IO.puts "removing any events after"
        IO.inspect queue
    end

    queue = generate_vertex_events(rect, queue, beachline, [index-1,nil,index], priority)

    midpoint = Geometry.circle(arc_a, arc_b, arc_c)

    sweep(rect, EventQueue.pop(queue), beachline,
      [ midpoint | voronoi_vertices], [ %HalfEdge{ voronoi_edges)
  end


  def sweep(rect, {{:value, priority, site}, queue}, beachline, voronoi_diagram, voronoi_edges) do

    IO.puts "\nsite event #{site.x},#{site.y} - priority #{priority}"

    IO.puts "\tcurrent beachline"
    IO.inspect beachline

    [ index: index, arc: arc ] = Beachline.find_arc(beachline, site, site.y)

    cond do
      arc == nil -> IO.puts "\tsite has no arc to split because the beachline is empty."
      true -> IO.puts "\tsite will split arc from focus at index #{index} (#{arc.x}, #{arc.y})"
    end

    cond do
      index > 0 and index < Enum.count(beachline) ->
        old_triple = [Enum.at(beachline, index-1), arc, Enum.at(beachline, index+1)]
        queue = EventQueue.remove(queue, old_triple)
      true ->
    end

    #IO.puts "\tinserting site (#{site.x}, #{site.y}) into beachline"
    [ beachline: new_beachline, indicies: indicies] = Beachline.insert(beachline, index, site)

    queue = generate_vertex_events(rect, queue, new_beachline, indicies, site.y)

    #Drawing.draw_frame(canvas, rect.size.width, site.y, new_beachline, current_frame)

    sweep(rect, EventQueue.pop(queue), new_beachline, voronoi_diagram, voronoi_edges)
  end

  def generate_vertex_events(rect, queue, beachline, indicies, sweep_line_y) do
    queue = generate_vertex_event(rect, queue, beachline, Enum.at(indicies, 0), sweep_line_y)
    generate_vertex_event(rect, queue, beachline, Enum.at(indicies, 2), sweep_line_y)
  end

  def generate_vertex_event(rect, queue, beachline, midarc_index, sweep_line_y) do
    IO.puts "Checking vertext event"
    IO.puts "\tcurrent beachline"
    IO.inspect beachline
    IO.puts "\tmidarc index #{midarc_index} (checking either side of that arc)"
    cond do
      midarc_index > 0 and midarc_index < Enum.count(beachline)-1 ->

        a = Enum.at(beachline, midarc_index-1)
        b = Enum.at(beachline, midarc_index)
        c = Enum.at(beachline, midarc_index+1)

        handle_circle_midpoint(rect, queue, Geometry.circle(a, b, c), [a, b, c], sweep_line_y)
      true -> queue
    end

  end

  defp handle_circle_midpoint(_, queue, false, _, _) do
    IO.puts "Those points do not form a circle"
    queue
  end

  defp handle_circle_midpoint(rect, queue, midpoint, triple, sweep_line_y) do
    IO.puts "\thandle circle midpoint for triple, midpoint"
    IO.inspect triple
    IO.inspect midpoint
    radius = Geometry.distance(midpoint, Enum.at(triple,0))

    cond do
      midpoint.y - radius < sweep_line_y ->
        IO.puts "\t\tading new vertex event to queue"
        IO.inspect queue
        EventQueue.push(queue, rect.size.height - (midpoint.y - radius), triple)
      true -> queue
    end
  end

end
