defmodule WippliBackendWeb.Router do
  use WippliBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WippliBackendWeb do
    pipe_through :api



    resources "/users", UserController, except: [:new, :edit]
    resources "/zones", ZoneController, except: [:edit] do
      resources "/participants/:user_id", ParticipantController, only: [:create, :delete]
    end

    resources "/zones/:zone_id/requests/", RequestController, only: [:create]
    resources "/requests/:request_id", VoteController, only: [:create, :update, :delete]
  end
end
