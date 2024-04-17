# Monitors
spawn(fn ->
  # spawn_monitor(fn ->
  Process.register(self(), B)

  receive do
    :crash -> 1 = 2
    :die_normally -> :ok
  end
end)

Process.monitor(B)
send(B, :crash)

receive do
  msg -> IO.inspect(msg, label: "A received")
after
  0 -> :ok
end
