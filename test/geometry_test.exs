defmodule GeometryTest do
  use ExUnit.Case
  doctest Geometry

  test "midpoint of a line with endpoint 0,0 and 4,0 is 2,0" do
    assert Geometry.midpoint(
      %Line{ origin: %Point{ x: 0, y: 0}, destination: %Point{ x: 4, y: 0}}) ==
      %Point{ x: 2, y: 0}
  end

  test "midpoint of a line with endpoint -1,-1 and 1,1 is 0,0" do
    assert Geometry.midpoint(
      %Line{ origin: %Point{ x: -1, y: -1}, destination: %Point{ x: 1, y: 1}}) ==
      %Point{ x: 0, y: 0}
  end

  test "midpoint of a line with endpoint 0,12 and 0,2 is 0,7" do
    assert Geometry.midpoint(
      %Line{ origin: %Point{ x: 0, y: 12}, destination: %Point{ x: 0, y: 2}}) ==
      %Point{ x: 0, y: 7}
  end

  test "distance from point at 0,0 and 4,0 is 4" do
    assert Geometry.distance(%Point{ x: 0, y: 0}, %Point{ x: 4, y: 0}) == 4
  end

  test "distance from point at -2,0 and 4,6 is 4" do
    assert_in_delta Geometry.distance(%Point{ x: -2, y: 0}, %Point{ x: 4, y: 6}), 8.4, 0.1
  end

  test "parabola of site at (4,3) with directrix at y = 1 has vertex at (4,2) and a p of 1" do
    assert Geometry.parabola(%Point{ x: 4, y: 3}, 1) == { %Point{ x: 4, y: 2}, 1}
  end

  test "parabola of site at (-5,5) with directrix at y = 1 has vertex at (-5,3) and a p of 2" do
    assert Geometry.parabola(%Point{ x: -5, y: 5}, 1) == { %Point{ x: -5, y: 3}, 2}
  end

  test "intersection of parabola of site (1,1) and site (-1,1) is (0,1) with tangent line at y = 0" do
    assert Geometry.intersection(%Point{ x: 1, y: 1}, %Point{ x: -1, y: 1 }, 0) == %Point{ x: 0, y: 1 }
  end

  test "intersection of parabola of site (3,5) and site (0,5) is (1.5,3.281) with tangent line at y = 1" do
    point = Geometry.intersection(
      %Point{ x: 3, y: 5}, %Point{ x: 0, y: 5 }, 1)
    assert_in_delta point.x, 1.5, 0.01
    assert_in_delta point.y, 3.28, 0.01
  end

  test "intersection of parabola of site (4,3) and site (-5,5) is about (-0.030,6.08) with tangent line at y = 1" do
    point = Geometry.intersection(
      %Point{ x: 4, y: 3}, %Point{ x: -5, y: 5 }, 1)
    assert_in_delta point.x, -0.039, 0.01
    assert_in_delta point.y, 6.07, 0.01
  end

  test "2 sites of 3 the same will not be distinct" do
    a = %Point{ x: 12, y: 10 }
    b = %Point{ x: 12, y: 9 }

    refute Geometry.distinct(a, a, b)
    refute Geometry.distinct(a, b, a)
    refute Geometry.distinct(b, a, a)

  end

  test "2 sites of 3 the same will be distinct" do
    a = %Point{ x: 12, y: 10 }
    b = %Point{ x: 12, y: 9 }
    c = %Point{ x: 6, y: 11 }

    assert Geometry.distinct(a, b, c)

  end

end
