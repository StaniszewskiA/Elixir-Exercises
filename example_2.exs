tell_next_fun = fn next_person ->
  receive do
    recived_gossip ->
      send(next_person, recived_gossip)
  end
end

lenard =
  spawn(fn ->
    receive do
      msg -> IO.inspect(msg, label: "Lenard received")
    end
  end)

raj = spawn(fn -> tell_next_fun.(lenard) end)
howard = spawn(fn -> tell_next_fun.(raj) end)
bernadete = spawn(fn -> tell_next_fun.(howard) end)

gossip = "Lenard bought the new Batman comix"

penny =
  spawn(fn ->
    Process.sleep(1000)
    send(bernadete, gossip)
  end)

[
  {:lenard, lenard},
  {:raj, raj},
  {:howard, howard},
  {:penny, penny},
  {:bernadete, bernadete}
] |> IO.inspect()

:dbg.tracer(:process, {&:dbg.dhandler/2, :standard_io})

for pid <- [lenard, raj, howard, bernadete, penny] do
  :dbg.p(pid, [:m])
end
