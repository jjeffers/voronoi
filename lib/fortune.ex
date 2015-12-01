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

    queue = Enum.reduce random_points, HeapQueue.new(), fn point, acc ->
      HeapQueue.push(acc, rect.size.height - point.y, point)
    end

    sweep(rect, HeapQueue.pop(queue), Beachline.new, Drawing.create_base_canvas(rect, random_points))
  end

  def sweep(rect, {:empty, _}, beachline, canvas) do
    IO.puts "done"
    IO.inspect beachline
  end

  def sweep(rect, {{:value, priority, point}, queue}, beachline, canvas) do

    IO.inspect point
    IO.puts "site event"

    beachline = RedBlackTree.insert beachline, %{ site: point }, point.x

    #draw_sweep_line_image(canvas, rect[:height], sweep_line_x_position)
    sweep(rect, HeapQueue.pop(queue), beachline, canvas)
  end

end
