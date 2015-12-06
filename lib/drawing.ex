defmodule Drawing do

  def create_base_canvas(rect, points) do
    canvas = Canvas.size(%Size{height: rect.size.height, width: rect.size.width}) |>
        Canvas.fill(color: Color.named(:white))

    Enum.reduce points, canvas, fn point, acc ->
      Canvas.fill(acc, color: Color.named(:blue),
                     rect: %Rect{ size: %Size{height: 1, width: 1},
                   origin: %Point{ x: point.x, y: point.y }})
      end


  end


  def draw_sweep_line_image(canvas, line_width, line_position, frame_number) do
    canvas_result = Canvas.fill(canvas, color: Color.named(:red),
                   rect: %Rect{ size: %Size{height: 1, width: line_width},
                 origin: %Point{ x: 1, y: line_position}})

    Bump.write(
      filename: "images/fortune_#{String.rjust("#{frame_number}", 4, 48)}.bmp",
      canvas: canvas_result)
  end

end
