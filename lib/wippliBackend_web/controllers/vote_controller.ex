defmodule WippliBackendWeb.VoteController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Vote

  action_fallback WippliBackendWeb.FallbackController

  def create(conn, %{"user_id" => user_id,  "request_id" => request_id, "rating" => rating}) do
    with {:ok, %Vote{} = vote} <- Wippli.create_vote(request_id, user_id, rating) do
      conn
      |> put_status(:created)
#      |> put_resp_header("location", request_path(conn, :show, vote))
      |> render("show.json", vote: vote)
    end
  end

  def update(conn, %{"zone_id" => zone_id, "request_id" => request_id, "user_id" => user_id, "rating" => rating}) do
    vote = Wippli.get_votes_by_user_for_request!(zone_id,request_id, user_id)
    with {:ok, %Vote{} = vote} <- Wippli.update_vote(vote, rating) do
      render(conn, "show.json", vote: vote)
    end
  end

  def delete(conn, %{"id" => id}) do
    vote = Wippli.get_vote!(id)
    with {:ok, %Vote{}} <- Wippli.delete_vote(vote) do
      send_resp(conn, :no_content, "")
    end
  end
end
