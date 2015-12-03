defmodule Beachline do

  def find_arc(beachline, site, y) do
    index = Beachline.binsearch(beachline, site, y)
    [ index: index, arc: Enum.at(beachline, index) ]
  end

  def binsearch(beachline, site, y) do
    binsearch(beachline, site, y, 0, length(beachline))
  end

  defp binsearch(beachline, _site, y, lo, hi) when hi < lo do
    -1
  end

  defp binsearch(beachline, site, y, lo, hi) do

    mid = div(lo + hi, 2)

    cond do
      Enum.count(beachline) < 3 -> mid
      true ->
        arc = Enum.at(beachline, mid)

        case compare_breakpoints(
          site, Enum.at(beachline, mid-1), arc, Enum.at(beachline, mid+1)) do
            -1 -> binsearch(beachline, site, y, lo, mid-1)
            0 -> mid
            1 -> binsearch(beachline, site, y, mid+1, hi)
        end

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
