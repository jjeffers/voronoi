defmodule Line do
  defstruct origin: %Point{}, destination: %Point{}
end

defmodule Geometry do

  def midpoint(line) do
    %Point{
      x: (line.origin.x+line.destination.x)/2,
      y: (line.origin.y+line.destination.y)/2};
  end

  def distance(point_a, point_b) do
    :math.sqrt(
      :math.pow(point_a.x - point_b.x, 2) +
      :math.pow(point_a.y - point_b.y, 2))
  end

  def parabola(nil, _) do
    raise "Focus was nil."
  end

  def parabola(_, nil) do
    raise "Directrix y coordinate was nil."
  end

  def parabola(focus, directrix_y) do
    vertex = midpoint(
      %Line{ origin: focus, destination: %Point{ x: focus.x, y: directrix_y }})

    { vertex, vertex.y - directrix_y }
  end

  def intersection(nil, _, _) do
    raise "First point argument was nil."
  end

  def intersection(_, nil, _) do
    raise "Second point argument was nil."
  end

  def intersection(_, _, nil) do
    raise "Directrix y coordinate was nil."
  end

  def intersection(point_a, point_b, y) do

    { vertex_a, p_a } = parabola(point_a, y)
    { vertex_b, p_b } = parabola(point_b, y)

    cond do
      point_a.y == point_b.y -> x = (point_a.x + point_b.x)/2
      point_b.y == y -> x = point_b.x
      point_a.y == y -> x = point_a.x
      true ->
        z_a = 4*p_a
        z_b = 4*p_b

        a = 1/z_a - 1/z_b
        b = -2*(vertex_a.x/z_a - vertex_b.x/z_b)
        c =  (vertex_a.x*vertex_a.x)/z_a - (vertex_b.x*vertex_b.x)/z_b +
          vertex_a.y - vertex_b.y

        x = (-b - :math.sqrt(b*b - 4*a*c))/(2*a)

    end

    y = ((x-vertex_a.x)*(x-vertex_a.x))/(4*p_a) + vertex_a.y

    %Point{ x: x, y: y }

  end

  def distinct(point_a, point_b, point_c) do
    cond do
      point_a.x == point_b.x and point_a.y == point_b.y -> false
      point_a.x == point_c.x and point_a.y == point_c.y -> false
      point_b.x == point_c.x and point_b.y == point_c.y -> false
      true -> true
    end
  end
end
