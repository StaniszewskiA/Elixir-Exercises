defmodule Exercise3 do
  def wait_and_print() do
    spawn(fn ->
      Process.register(self(), :hello)

      receive do
        :ping = msg ->
          IO.inspect(msg)
      end
    end)
  end
end
