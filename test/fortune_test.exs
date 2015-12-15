defmodule FortuneTest do
  use ExUnit.Case
  doctest Fortune

  test "2 points, co linear, produces a single Voronoi vertex" do
    rect = %Rect{
      size: %Size{height: 10, width: 30},
      origin: %Point{ x: 0, y: 0}
    }

    points = [
      %Point{ x: 2, y: 5.449 },
      %Point{ x: 4.45, y: 3},
      %Point{ x: 0, y: 1.586}
    ]

    Geometry.assert_equal Enum.at(Fortune.fortune(rect, points), 0),
      %Point{ x: 2, y: 3}
  end
end
