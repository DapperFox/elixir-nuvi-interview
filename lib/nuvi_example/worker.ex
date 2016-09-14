defmodule NuviExample.Worker do

  @url "http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/"

  def start_link do
    pid = spawn_link &__MODULE__.download_zips/0
    { :ok, pid }
  end

  def get_zips do
    HTTPoison.get!(@url)
      |> Map.get(:body)
      |> Floki.find("a")
      |> Floki.attribute("href")
  end

  def download_zips do
    Enum.each(get_zips, &(fetch_zip(&1)))
  end

  def fetch_zip(zip_path) do
    if (String.ends_with?(zip_path, ".zip")) do
      HTTPoison.get!(@url <> zip_path)
      |> IO.inspect
    end
    System.Halt
  end
end
