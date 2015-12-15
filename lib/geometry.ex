defmodule Line do
  defstruct origin: %Point{}, destination: %Point{}
end

defimpl String.Chars, for: Point do
  def to_string(point) do
    "(#{point.x},#{point.y})"
  end
end

defmodule Geometry do

  def assert_equal(point_a, point_b, delta \\ 0.01) do
    ExUnit.Assertions.assert_in_delta point_a.x, point_b.x, delta
    ExUnit.Assertions.assert_in_delta point_a.y, point_b.y, delta
  end

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

  def intersection(point_a, point_a, _) do
    point_a
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

    y = parabola_y(vertex_a, x, p_a)

    %Point{ x: x, y: y }

  end

  def parabola_y(_, _, 0.0) do
    {:error, "Length of p cannot be 0"}
  end

  def parabola_y(vertex, x, p) do
    ((x-vertex.x)*(x-vertex.x))/(4*p) + vertex.y
  end

  def distinct(point_a, point_b, point_c) do
    cond do
      point_a.x == point_b.x and point_a.y == point_b.y -> false
      point_a.x == point_c.x and point_a.y == point_c.y -> false
      point_b.x == point_c.x and point_b.y == point_c.y -> false
      true -> true
    end
  end

  def circle(a, b, c) do
    cond do
      colinear(a, b, c) -> false
      true -> compute_midpoint(a, b, c)
    end
  end

  def compute_midpoint(point_a, point_b, point_c) do

    a = point_b.x - point_a.x
    b = point_b.y - point_a.y
    c = point_c.x - point_a.x
    d = point_c.y - point_a.y

    e = (a * (point_a.x+point_b.x)) + (b * (point_a.y+point_b.y))
    f = (c * (point_a.x+point_c.x)) + (d * (point_a.y+point_c.y))
    g = 2 * ((a * (point_c.y-point_b.y)) - (b * (point_c.x-point_b.x)))

    %Point{ x: ((d*e)-(b*f))/g, y: ((a*f)-(c*e))/g }
  end

  def colinear(a, b, c) do
    (a.x*(b.y-c.y)) + (b.x*(c.y - a.y)) + (c.x*(a.y-b.y)) == 0
  end
end
