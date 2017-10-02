defmodule WippliBackendWeb.Router do
  use WippliBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WippliBackendWeb do
    pipe_through :api



    resources "/users", UserController, except: [:new, :edit]
    resources "/zones", ZoneController do
      resources "/participants/:user_id", ParticipantController, only: [:create, :delete]

    end



    resources "/zones/:zone_id/requests/", RequestController, only: [:list, :create]
    resources "/votes", VoteController, except: [:new, :edit]
  end
end
