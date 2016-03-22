defmodule TelnetNiceThings do
  def listen(port) do
    {:ok, blob_of_nice} = File.read("compliments.dat")
    list_of_nice = String.split(blob_of_nice, "\n")
    # spawn a process to hold the list_of_nice state
    Agent.start_link(fn -> list_of_nice end, name: :nice_things_db)

    tcp_options = [:binary, active: false, packet: :line, reuseaddr: true]
    {:ok, socket} = :gen_tcp.listen(port, tcp_options)
    IO.puts("bringing joy on #{port}!")
    accept_and_serve(socket)
  end

  # ... accept_and_serve definition
  defp accept_and_serve(listen_socket) do
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)
    # spawn a process to serve this client (think goroutine)
    spawn(fn() -> say_nice_things(client_socket) end)
    accept_and_serve(listen_socket)
  end

  # ... say_nice_things definition
  defp say_nice_things(socket) do
    prompt = "are you feeling better?> "
    :gen_tcp.send(socket, prompt)
    {:ok, status_raw} = :gen_tcp.recv(socket, 0)
    status = String.rstrip(to_string(status_raw))
    case status do
      "y" -> 
        :gen_tcp.send(socket, "hooray!\n")
        :gen_tcp.close(socket)
      "n" ->
        # query the :nice_things_db process for some state
        nice_thing = Agent.get(:nice_things_db, fn(list_of_nice) ->
            Enum.random(list_of_nice)
        end)
        msg = IO.ANSI.green() <> nice_thing <> IO.ANSI.reset()
        :gen_tcp.send(socket, "#{msg}\n")
        say_nice_things(socket)
      _ ->
        :gen_tcp.send(socket, "Not sure what that means.\n")
        say_nice_things(socket)
    end
  end
end
TelnetNiceThings.listen(4242);
