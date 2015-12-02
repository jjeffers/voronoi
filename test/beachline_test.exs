defmodule BeachlineTest do
  use ExUnit.Case
  doctest Beachline

  test "a beachline with a single arc contains any new single site" do
    arc = %Point{ x: 10, y: 100 }
    site = %Point{ x: 6, y: 80 }
    sweep_line_y = 80

    assert [arc]
      |> Beachline.find_arc(site, sweep_line_y) == [ index: 0, arc: arc ]

  end

  test "a beachline with three arcs matches a site" do
    arc = %Point{ x: 10, y: 100 }
    site = %Point{ x: 6, y: 80 }
    sweep_line_y = 80

    assert [arc]
      |> Beachline.find_arc(site, sweep_line_y) == [ index: 0, arc: arc ]

  end

  test "site falls between into first arc" do
    arc_a = %Point{ x: 20, y: 15 }
    arc_b = %Point{ x: 30, y: 20 }
    arc_c = %Point{ x: 40, y: 22 }

    site = %Point{ x: 25, y: 10 }
    sweep_line_y = 10

    assert Beachline.compare_breakpoints(site.x, arc_a, arc_b, arc_c, 10) == -1

  end

  test "a beachline with three arcs matches an interior arc" do
    arc_a = %Point{ x: 20, y: 15 }
    arc_b = %Point{ x: 30, y: 20 }
    arc_c = %Point{ x: 40, y: 22 }

    site = %Point{ x: 27, y: 10 }
    sweep_line_y = 10

    assert Beachline.compare_breakpoints(site.x, arc_a, arc_b, arc_c, 10) == 0

  end

  test "a beachline with three arcs matches the last arc" do
    arc_a = %Point{ x: 20, y: 15 }
    arc_b = %Point{ x: 30, y: 20 }
    arc_c = %Point{ x: 40, y: 22 }

    site = %Point{ x: 37, y: 10 }
    sweep_line_y = 10

    assert Beachline.compare_breakpoints(site.x, arc_a, arc_b, arc_c, 10) == 1

  end
end
