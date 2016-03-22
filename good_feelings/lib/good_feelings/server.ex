defmodule GoodFeelings.Server do
  use GenServer
  require Logger

  # public/client API
  def start_link() do
    Logger.warn("starting a server - ask for green!")
    GenServer.start_link(__MODULE__, [], name: :nice_server)
  end

  def green() do
    message = GenServer.call(:nice_server, :green)
    IO.puts message
  end

  # callbacks
  def handle_call(:green, _from, state) do
    {:reply, colorful_phrase(:green), state}
  end

  def handle_call(:blue, _from, state) do
    {:reply, colorful_phrase(:blue), state}
  end

  def handle_call(:yellow, _from, state) do
    {:reply, colorful_phrase(:yellow), state}
  end

  # implementations
  defp colorful_phrase(color) do
    phrase = GoodFeelings.Db.get_nice_thing()
    escape_seq = case color do
      :green ->
        IO.ANSI.green()
      :blue ->
        IO.ANSI.blue()
    # nobody likes yellow
    # :yellow -> 
    #   IO.ANSI.yellow()

    end
    escape_seq <> phrase <> IO.ANSI.reset()
  end
end
