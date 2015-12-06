defmodule EventQueue do

  def new, do: HeapQueue.new

  def push(queue, priority, value) do
    HeapQueue.push(queue, priority, value)
  end

  def pop(queue) do
    HeapQueue.pop(queue)
  end

  def remove_any(queue, event_to_remove) do
    _remove_any(EventQueue.pop(queue), event_to_remove, EventQueue.new)
  end

  defp _remove_any({:empty, _}, _, new_queue) do
    new_queue
  end

  defp _remove_any({{:value, priority, event}, queue}, event_to_remove, new_queue) do

    cond do
      event == event_to_remove ->
        _remove_any(EventQueue.pop(queue), event_to_remove, new_queue)
      true ->
        _remove_any(EventQueue.pop(queue), event_to_remove, EventQueue.push(new_queue, priority, event))
    end

  end

  def to_list(queue) do
    HeapQueue.to_list(queue)
  end

end
