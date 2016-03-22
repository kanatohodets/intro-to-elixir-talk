defmodule GoodFeelings.Db do
  use GenServer
  require Logger
  # public/client API
  def start_link(filename) do
    Logger.warn("starting a database: plenty of nice things")
    GenServer.start_link(__MODULE__, [filename], name: :nice_db)
  end

  def get_nice_thing() do
    GenServer.call(:nice_db, :request_nice)
  end

  # callbacks
  def init([filename]) do
    {:ok, blob_of_nice} = File.read(filename)
    list_of_nice = String.split(blob_of_nice, "\n")
    # 'state' map travels with every call to this process
    state = %{ nice_things: list_of_nice}
    {:ok, state}
  end

  def handle_call(:request_nice, _from, %{nice_things: nice_list} = state) do
    {:reply, Enum.random(nice_list), state}
  end
end
