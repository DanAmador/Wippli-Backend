defmodule WippliBackendWeb.VoteController do
  use WippliBackendWeb, :controller

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Vote

  action_fallback WippliBackendWeb.FallbackController

  def index(conn, _params) do
    votes = Wippli.list_votes()
    render(conn, "index.json", votes: votes)
  end

  def create(conn, %{"vote" => vote_params}) do
    with {:ok, %Vote{} = vote} <- Wippli.create_vote(vote_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", vote_path(conn, :show, vote))
      |> render("show.json", vote: vote)
    end
  end

  def show(conn, %{"id" => id}) do
    vote = Wippli.get_vote!(id)
    render(conn, "show.json", vote: vote)
  end

  def update(conn, %{"id" => id, "vote" => vote_params}) do
    vote = Wippli.get_vote!(id)

    with {:ok, %Vote{} = vote} <- Wippli.update_vote(vote, vote_params) do
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
