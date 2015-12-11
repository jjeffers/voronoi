defmodule Beachline do


  def find_arc(beachline, site, directrix_y) do
    index = Beachline.binsearch(beachline, site, directrix_y)
    [ index: index, arc: Enum.at(beachline, index) ]
  end

  def find_arc([], _) do
    [ index: 0, arc: nil ]
  end

  def find_arc(beachline, site) do
    _find_arc(beachline, site, 0)
  end

  defp _find_arc([], _, _) do
    [ index: 0, arc: nil ]
  end

  defp _find_arc([ arc | tail ], site, index) do

    cond do
      site.x == arc.x and site.y == arc.y -> [ index: index, arc: arc ]
      true -> _find_arc(tail, site, index+1)
    end
  end

  def insert([], index, new_arc) do
    [beachline: [new_arc], indicies: [0]]
  end

  def insert(beachline, index, new_arc) do
    arc = Enum.at(beachline, index)
    new_beachline = List.insert_at(beachline, index, arc)
    |>  List.replace_at(index+1, new_arc)
    |>  List.insert_at(index+2, arc)

    [ beachline: new_beachline, indicies: [index, index+1, index+2]]
  end

  def delete_at(beachline, index) do
    List.delete_at(beachline, index)
  end

  def delete(beachline, arc) do
    List.delete(beachline, arc)
  end

  def binsearch(beachline, site, directrix_y) do
    binsearch(beachline, site, 0, length(beachline), directrix_y)
  end

  defp binsearch(beachline, _site, lo, hi, _) when hi < lo do
    -1
  end

  defp binsearch(beachline, site, lo, hi, directrix_y) do

    mid = div(lo + hi, 2)

    cond do
      Enum.count(beachline) < 3 -> mid
      true ->
        arc = Enum.at(beachline, mid)

        case compare_breakpoints(
          site, Enum.at(beachline, mid-1), arc, Enum.at(beachline, mid+1), directrix_y) do
            -1 -> binsearch(beachline, site, lo, mid-1, directrix_y)
            0 -> mid
            1 -> binsearch(beachline, site, mid+1, hi, directrix_y)
        end

      end

  end

  def compare_breakpoints(site, arc_left, arc_mid, nil, directrix_y) do

    left_breakpoint = Geometry.intersection(arc_mid, arc_left, directrix_y)

    cond do
      site.x < left_breakpoint.x -> -1
      true -> 0
    end

  end

  def compare_breakpoints(site, arc_left, arc_mid, arc_right, directrix_y) do

    left_breakpoint = Geometry.intersection(arc_mid, arc_left, directrix_y)
    right_breakpoint = Geometry.intersection(arc_right, arc_mid, directrix_y)

    cond do
      site.x >= left_breakpoint.x and site.x <= right_breakpoint.x -> 0
      site.x < left_breakpoint.x -> -1
      site.x > right_breakpoint.x -> 1
      true -> 0
    end

  end

end
