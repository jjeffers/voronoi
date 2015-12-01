defmodule Drawing do

  def create_base_canvas(rect, points) do
    IO.puts "creating base canvas"
    canvas = Canvas.size(%Size{height: rect.size.height, width: rect.size.width}) |>
        Canvas.fill(color: Color.named(:white))

    Enum.reduce points, canvas, fn point, acc ->
      Canvas.fill(acc, color: Color.named(:blue),
                     rect: %Rect{ size: %Size{height: 1, width: 1},
                   origin: %Point{ x: point.x, y: point.y }})
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
