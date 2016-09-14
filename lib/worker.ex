defmodule NuviExample.Worker do
  def start_link do
    pid = spawn_link &__MODULE__.get_zips/0
    { :ok, pid }
  end

  def get_zips do
    body = HTTPoison.get!("http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/")
      |> Map.get(:body)
      |> IO.inspect
    Regex.run(~r/<a\s+(?:[^>]*?\s+)?href=\\"([^"]*)"/, body)

    System.halt
  end
end
