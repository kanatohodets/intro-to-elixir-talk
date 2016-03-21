defmodule SayNiceThings do
  def start do
    {:ok, blob_of_nice} = File.read("compliments.dat")
    list_of_nice = String.split(blob_of_nice, "\n")
    say_nice_things(list_of_nice)
  end
 
  defp say_nice_things(list_of_nice) do
    # just like: status = String.strip(IO.gets("..."))
    status = 
      IO.gets("Are you feeling better? (y/n) ") |> String.strip
    case status do
      "y" -> 
        IO.puts "hooray!"
      "n" ->
        IO.puts IO.ANSI.green() <> Enum.random(list_of_nice) <> IO.ANSI.reset()
        say_nice_things(list_of_nice)
      _ ->
        IO.puts "Not sure what that means."
        say_nice_things(list_of_nice)
    end
  end
end
SayNiceThings.start
