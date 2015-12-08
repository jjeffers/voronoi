defmodule Beachline do

  def find_arc(beachline, site) do
    index = Beachline.binsearch(beachline, site)
    [ index: index, arc: Enum.at(beachline, index) ]
  end

  def insert([], index, new_arc) do
    [new_arc]
  end

  def insert(beachline, index, new_arc) do
    arc = Enum.at(beachline, index)
    new_beachline = List.insert_at(beachline, index, arc)
    |>  List.replace_at(index+1, new_arc)
    |>  List.insert_at(index+2, arc)
    [ beachline: new_beachline, indicies: [index, index+1, index+2]]
  end

  def binsearch(beachline, site) do
    binsearch(beachline, site, 0, length(beachline))
  end

  defp binsearch(beachline, _site, lo, hi) when hi < lo do
    -1
  end

  defp binsearch(beachline, site, lo, hi) do

    mid = div(lo + hi, 2)

    cond do
      Enum.count(beachline) < 3 -> mid
      true ->
        arc = Enum.at(beachline, mid)

        case compare_breakpoints(
          site, Enum.at(beachline, mid-1), arc, Enum.at(beachline, mid+1)) do
            -1 -> binsearch(beachline, site, lo, mid-1)
            0 -> mid
            1 -> binsearch(beachline, site, mid+1, hi)
        end

      end

  end

  def compare_breakpoints(site, arc_left, arc_mid, nil) do

    left_breakpoint = Geometry.intersection(arc_mid, arc_left, site.y)

    cond do
      site.x < left_breakpoint.x -> -1
      true -> 0
    end

  end

  def compare_breakpoints(site, arc_left, arc_mid, arc_right) do

    left_breakpoint = Geometry.intersection(arc_mid, arc_left, site.y)
    right_breakpoint = Geometry.intersection(arc_right, arc_mid, site.y)

    cond do
      site.x >= left_breakpoint.x and site.x <= right_breakpoint.x -> 0
      site.x < left_breakpoint.x -> -1
      site.x > right_breakpoint.x -> 1
      true -> 0
    end

  end

end
