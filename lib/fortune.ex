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
    IO.inspect beachline
  end

  def sweep(rect, {{:value, priority, site}, queue}, beachline, canvas, current_frame) do

    IO.puts "site event"
    IO.inspect site

    [ index: index, arc: arc ] = Beachline.find_arc(beachline, site)

    old_triple = [Enum.at(index-1), arc, Enum.at(index+1)]

    queue = EventQueue.remove(queue, old_triple)

    beachline = Beachline.insert(beachline, index, site)

    Drawing.draw_sweep_line_image(canvas, rect.size.width, site.y, current_frame)

    sweep(rect, EventQueue.pop(queue), beachline, canvas, current_frame+1)
  end


end
