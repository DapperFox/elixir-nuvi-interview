defmodule NuviExample.Worker do

  @url "http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/"

  def start_link do
    pid = spawn_link &__MODULE__.get_zips/0
    { :ok, pid }
  end

  def get_zips do
    HTTPoison.get!(@url)
      |> Map.get(:body)
      |> Floki.find("a")
      |> Floki.attribute("href")
  end

  def download_zips do
    Enum.each(get_zips, fn (zip_path) -> fetch_zip(zip_path) end)
  end

  def fetch_zip(zip_path) do
    IO.puts(zip_path)
    HTTPoison.get!(@url + zip_path)
  end
end
