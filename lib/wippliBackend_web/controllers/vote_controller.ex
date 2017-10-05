defmodule WippliBackendWeb.VoteController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Vote

  action_fallback WippliBackendWeb.FallbackController

  def create(conn, %{"user_id" => user_id,  "request_id" => request_id, "rating" => rating}) do
      with {:ok, status} <- Wippli.create_or_update_vote(request_id, user_id, rating) do
      conn
      |> send_resp(status, "")
    end
  end
end
