a = spawn(fn ->
  Process.register(self(), A)

  receive do
    {:string, value} ->
      IO.puts("Hello #{value}")
  end
end)

IO.inspect({A, self()}, label: "I am")

send(A, {:string, "World"})
