defmodule Exercise1 do
  def send_to_pong() do
    spawn(fn ->
      send(:ping, :pong)
    end)
  end
end

Exercise1.send_to_pong()
