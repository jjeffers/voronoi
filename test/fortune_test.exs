defmodule FortuneTest do
  use ExUnit.Case
  doctest Fortune

  test "3 points on a circle produce a single Voronoi vertex" do
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

  test "3 points, co linear, produces 3 Vornoi vertices" do
    rect = %Rect{
      size: %Size{height: 10, width: 30},
      origin: %Point{ x: 0, y: 0}
    }

    points = [
      %Point{ x: 7, y: 5 },
      %Point{ x: 15, y: 5},
      %Point{ x: 23, y: 5 }
    ]

    Geometry.assert_equal Enum.at(Fortune.fortune(rect, points), 0),
      %Point{ x: 4, y: 5}
  end

  test "example voronoi set" do
    rect = %Rect{
      size: %Size{height: 110, width: 110},
      origin: %Point{ x: 0, y: 0}
    }

    points = [
      %Point{ x: 100, y: 100},
      %Point{ x: 0, y: 100},
      %Point{ x: 30, y: 60},

    ]

    expected_points = [

      %Point{ x: 50, y: 106.25 },
      %Point{ x: 57.6316, y: 92.8947 },
      %Point{ x: 64.286, y: 73.5714 },
      %Point{ x: 50, y: 70 },
      %Point{ x: -52.5000 ,  y: 50 },
      %Point{ x: 30, y: 50 },
      %Point{ x: 111.25, y: 50 }

    ]

    diagram = Fortune.fortune(rect, Enum.sort(points, &(&1.y > &2.y)))

    Drawing.create_base_canvas(rect, points) |>
    Drawing.draw_points(expected_points, :red) |>
    Drawing.draw_voronoi_diagram(diagram)


    IO.puts "final output:"
    IO.inspect diagram

    assert 12 == Enum.count(diagram)
  end

  test "example voronoi set 2" do
    rect = %Rect{
      size: %Size{height: 40, width: 40},
      origin: %Point{ x: 0, y: 0}
    }

    points = [
      %Point{ x: 20, y: 30},
      %Point{ x: 30, y: 20},
      %Point{ x: 10, y: 10},

    ]

    expected_points = [

      %Point{ x: 18.3, y: 18.3 }
    ]

    diagram = Fortune.fortune(rect, Enum.sort(points, &(&1.y > &2.y)))

    Drawing.create_base_canvas(rect, points) |>
    Drawing.draw_points(expected_points, :red) |>
    Drawing.draw_voronoi_diagram(diagram)


    IO.puts "final output:"
    IO.inspect diagram

    assert 1 == Enum.count(diagram)
  end
end
