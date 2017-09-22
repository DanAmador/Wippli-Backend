defmodule WippliBackendWeb.Router do
  use WippliBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WippliBackendWeb do
    pipe_through :api

    
    resources "/zones", ZoneController, except: [:update]

    resources "/songs", SongController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    resources "/playlist_songs", PlaylistSongController, except: [:new, :edit]
    resources "/votes", VoteController, except: [:new, :edit]
  end
end
