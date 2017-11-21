defmodule WippliBackend.Wippli.RequestHelper do
  alias WippliBackend.Wippli.RequestHelper.YouTubePoison

  def valid_url(url) do
    case URI.parse(url) do
      %URI{scheme: nil} -> {:error, "No scheme"}
      %URI{host: nil} -> {:error, "No host"}
      _ -> {:ok, url}
    end
  end

  def parse_url(song_url) do
    uri_struct = URI.parse(song_url)
    case uri_struct.host do
      "www.youtube.com" -> uri_struct.query |> URI.decode_query |> Map.get("v") |> handle_yt("videos")
      "youtu.be" -> uri_struct.path |> String.replace("/", "") |> String.split("&") |> List.first
|> handle_yt("videos")
      _ -> {:error, :bad_request}
    end
  end

  defp handle_yt(id, type) do
    response = YouTubePoison.get!(type, [], params: %{id: id, part: "snippet"})
    result = List.first(response.body["items"])
    %{
      title: result["snippet"]["title"],
      thumbnail: result["snippet"]["thumbnails"]["default"]["url"],
      source_id: id,
      url: "http://youtu.be/" <> result["id"]
    }
  end

  defmodule YouTubePoison do
    use HTTPoison.Base

    defmodule Response do
      defstruct [:id, :kind, :snippet]
    end

    def process_url(url) do
      "https://www.googleapis.com/youtube/v3/" <> url <> "&key=" <> Application.get_env(:wippliBackend, :yt_key)
    end

    def process_response_body(body) do
      body
      |> Poison.decode!(as: %{"body" => %{"items" => [%{"data" => Entry}]}})
    end
 end
end
