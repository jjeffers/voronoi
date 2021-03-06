defmodule BeachlineTest do
  use ExUnit.Case
  doctest Beachline

  test "a site falls to the 'left' of the first arc" do
    arc = %Point{ x: 2, y: 5.449 }
    site = %Point{ x: 0, y: 1.586 }

    assert [%Point{x: 2, y: 5.449}, %Point{x: 4.45, y: 3}, %Point{x: 2, y: 5.449}]
      |> Beachline.find_arc(site, site.y) == [ index: 0, arc: arc ]
  end

  test "a beachline with a single arc contains any new single site" do
    arc = %Point{ x: 10, y: 100 }
    site = %Point{ x: 6, y: 80 }

    assert [arc]
      |> Beachline.find_arc(site, site.y) == [ index: 0, arc: arc ]

  end

  test "a beachline no arcs returns bad index and null arc" do

    site = %Point{ x: 6, y: 80 }

    assert []
      |> Beachline.find_arc(site) == [ index: 0, arc: nil ]

  end

  test "finds an arc in large beachline" do
    beachline = [
      %Point{x: 56, y: 499}, %Point{x: 279, y: 462}, %Point{x: 326, y: 460},
      %Point{x: 279, y: 462}, %Point{x: 56, y: 499}]

    assert [ index: 1, arc: %Point{x: 279, y: 462}] ==
      Beachline.find_arc(beachline, %Point{x: 279, y: 462})

  end

  test "a beachline with three arcs matches a site" do
    arc = %Point{ x: 10, y: 100 }
    site = %Point{ x: 6, y: 80 }

    assert [arc]
      |> Beachline.find_arc(site) == [ index: 0, arc: nil ]

  end

  test "site falls between into first arc" do
    arc_a = %Point{ x: 20, y: 15 }
    arc_b = %Point{ x: 30, y: 20 }
    arc_c = %Point{ x: 40, y: 22 }

    site = %Point{ x: 25, y: 10 }

    assert Beachline.compare_breakpoints(site, arc_a, arc_b, arc_c, site.y) == -1

  end

  test "a beachline with three arcs matches an interior arc" do
    arc_a = %Point{ x: 20, y: 15 }
    arc_b = %Point{ x: 30, y: 20 }
    arc_c = %Point{ x: 40, y: 22 }

    site = %Point{ x: 27, y: 10 }

    assert Beachline.compare_breakpoints(site, arc_a, arc_b, arc_c, site.y) == 0

  end

  test "a beachline with three arcs matches the last arc" do
    arc_a = %Point{ x: 20, y: 15 }
    arc_b = %Point{ x: 30, y: 20 }
    arc_c = %Point{ x: 40, y: 22 }

    site = %Point{ x: 37, y: 10 }

    assert Beachline.compare_breakpoints(site, arc_a, arc_b, arc_c, site.y) == 1

  end


  test "with l=2, for an arc A from focus at (20,15), split by an arc B with focus at (18,5), site at (10,2) falls into arc A" do
    arc_a = %Point{ x: 20, y: 15 }
    arc_b = %Point{ x: 18, y: 5 }

    site = %Point{ x: 10, y: 2 }

    assert Beachline.compare_breakpoints(site, arc_a, arc_b, arc_a, site.y) == -1

  end

  test "with l=2, for an arc A from focus at (20,15), split by an arc B with focus at (18,5), site at (14,2) falls into arc B" do
    arc_a = %Point{ x: 20, y: 15 }
    arc_b = %Point{ x: 18, y: 5 }

    site = %Point{ x: 14, y: 2 }

    assert Beachline.compare_breakpoints(site, arc_a, arc_b, arc_a, site.y) == 0

  end

  test "with l=2, for an arc A from focus at (20,15), split by an arc B with focus at (18,5), site at (24,2) falls into arc B" do
    arc_a = %Point{ x: 20, y: 15 }
    arc_b = %Point{ x: 18, y: 5 }

    site = %Point{ x: 14, y: 2 }

    assert Beachline.compare_breakpoints(site, arc_a, arc_b, arc_a, site.y) == 0

  end

  test "inserting an arc into an empty list" do
      assert []
        |> Beachline.insert(0, %Point{ x: 12, y: 5}) ==
        [ beachline: [%Point{ x: 12, y: 5}], indicies: [0]]
  end

  test "inserting an arc splits the current arc" do
      assert ["a", "b", "c"]
        |> Beachline.insert(1, "z") == [ beachline: ["a", "b", "z", "b", "c"], indicies: [1, 2, 3]]
  end

  test "inserting an arc at the beginning splits the current arc" do
      assert ["a", "b", "c"]
        |> Beachline.insert(0, "z") == [beachline: ["a", "z", "a", "b", "c"], indicies: [0, 1, 2]]
  end

  test "inserting an arc at the end splits the current arc" do
      assert ["a", "b", "c"]
        |> Beachline.insert(2, "z") == [beachline: ["a", "b", "c", "z", "c"], indicies: [2, 3, 4]]
  end


end
