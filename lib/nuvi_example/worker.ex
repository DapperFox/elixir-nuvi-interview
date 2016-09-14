defmodule NuviExample.Worker do
  import Exredis
  @url "http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/"

  def start_link do
    pid = spawn_link &__MODULE__.download_zips/0
    { :ok, pid }
  end

  def download_zips do
    Enum.each(get_zip_urls, &(fetch_zip(&1)))
  end

  def get_zip_urls do
    HTTPoison.get!(@url)
      |> Map.get(:body)
      |> Floki.find("a")
      |> Floki.attribute("href")
  end

  def fetch_zip(zip_path) do
    if (String.ends_with?(zip_path, ".zip")) do
      HTTPoison.get!(@url <> zip_path).body
        |> :zip.unzip([:memory])
        |> redis
    end
  end

  def client do
    {:ok, client} = Exredis.start_link
    client
  end

  def sadd(xml_data) do
    client |> Exredis.Api.sadd("NEWS_XML", xml_data)
  end
end
