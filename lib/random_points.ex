defmodule RandomPoints do

  def generate_random_points(rect, number_of_points, list_of_points \\ [])

  def generate_random_points(_, 0, list_of_points) do
    list_of_points
  end

  def generate_random_points(rect, number_of_points, list_of_points) do
    generate_random_points(rect, number_of_points-1, [generate_random_point(rect) | list_of_points])
  end

  defp generate_random_point(rect) do
    %Point{
      x: pick_random(rect.origin.x..rect.size.width),
      y: pick_random(rect.origin.y..rect.size.width)
    }
  end

  defp pick_random(range) do
    Enum.random(range)
  end

end
