defmodule Wippli.SongFactory do
  alias WippliBackend.Wippli.Song
  defmacro __using__(_opts) do
    quote do
      def song_factory do
        %Song{
          id: 1,
          source_id: "PLIJc7YE_jw",
          thumbnail: "https://i.ytimg.com/vi/PLIJc7YE_jw/hqdefault.jpg",
          title: "Barack Obama Singing Can't Touch This by MC Hammer",
          url: "https://youtu.be/PLIJc7YE_jw"
        }
      end
    end
  end
end
