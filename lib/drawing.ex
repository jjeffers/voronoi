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

  defp draw_sweep_line(canvas, line_width, line_position) do
    Canvas.fill(canvas, color: Color.named(:red),
      rect: %Rect{ size: %Size{height: 1, width: line_width},
      origin: %Point{ x: 1, y: line_position}})
  end


  def draw_frame(canvas, line_width, line_position, beachline, frame_number) do
    sweep_line_canvas = draw_sweep_line(canvas, line_width, line_position)

    cavas_final = draw_beachline(sweep_line_canvas, beachline, line_position)

    Bump.write(
      filename: "images/fortune_#{String.rjust("#{frame_number}", 4, 48)}.bmp",
      canvas: cavas_final)
  end

  defp draw_beachline(canvas, [], _) do
    canvas
  end

  defp draw_beachline(canvas, beachline, line_position) do
    current_focus = hd(beachline)

    new_canvas = draw_parabola(canvas, current_focus, line_position)

    draw_beachline(new_canvas, tl(beachline), line_position)
  end

  defp draw_parabola(canvas, %Point{ x: _, y: y}, y) do
    canvas
  end

  defp draw_parabola(canvas, focus, directrix_y) do

    { vertex, p } = Geometry.parabola(focus, directrix_y)

    width = Canvas.size(canvas).width
    queue = Enum.reduce 1..width, canvas, fn x, acc ->

      y = (1/(4*p))*((x-vertex.x)*(x-vertex.x))+vertex.y

      Canvas.fill(acc, color: Color.named(:black),
                     rect: %Rect{ size: %Size{height: 1, width: 1},
                   origin: %Point{ x: x, y: y }})

    end

  end



end
