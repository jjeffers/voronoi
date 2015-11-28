defmodule Fortune do

  def main(_) do
    :random.seed(:erlang.now)
    rect = [ x_origin: 0, width: 500, y_origin: 0, height: 500]
    random_points = generate_random_points(rect, 50)

    queue = HeapQueue.new()

    queue = Enum.reduce random_points, queue, fn point, acc ->
      HeapQueue.push(acc, rect[:height] - point[:y], point)
    end

    sweep(rect, queue, create_base_canvas(rect, random_points))
  end

  def sweep(rect, {:empty, _}, canvase) do
    IO.puts "done"
  end

  def sweep(rect, points, sweep_line_x_position, canvas) do
    IO.puts "sweep at #{sweep_line_x_position}"
    IO.puts "going to draw sweep line"

    draw_sweep_line_image(canvas, rect[:height], sweep_line_x_position)
    sweep(rect, points, sweep_line_x_position+1, canvas)
  end

  defp generate_random_points(_, 0, list_of_points) do
    list_of_points
  end

  defp generate_random_points(rect, number_of_points, list_of_points \\ []) do
    generate_random_points(rect, number_of_points-1, [generate_random_point(rect) | list_of_points])
  end

  defp generate_random_point(rect) do
    [ x: pick_random(rect[:x_origin]..rect[:width]), y: pick_random(rect[:y_origin]..rect[:height])]
  end

  defp pick_random(range) do
    Enum.random(range)
  end

  def create_base_canvas(rect, points) do
    IO.puts "creating base canvas"
    canvas = Canvas.size(%Size{height: rect[:height], width: rect[:width]}) |>
        Canvas.fill(color: Color.named(:white))

    Enum.reduce points, canvas, fn point, acc ->
      Canvas.fill(acc, color: Color.named(:blue),
                     rect: %Rect{ size: %Size{height: 1, width: 1},
                   origin: %Point{ x: point[:x], y: point[:y]}})
      end


  end


  def draw_sweep_line_image(canvas, line_height, line_position) do
    IO.puts "drawing sweep line at position #{line_position}"
    canvas_result = Canvas.fill(canvas, color: Color.named(:red),
                   rect: %Rect{ size: %Size{height: line_height, width: 1},
                 origin: %Point{ x: line_position, y: 1}})

    Bump.write(filename: "images/fortune_#{line_position}.bmp", canvas: canvas_result)
  end


end
