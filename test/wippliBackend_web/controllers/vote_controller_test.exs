defmodule WippliBackendWeb.VoteControllerTest do
  use WippliBackendWeb.ConnCase

  import Wippli.Factory
  alias WippliBackend.Wippli

  @create_attrs %{rating: 42, user_id: 1}
  @update_attrs %{rating: 404040, user_id: 1}
  @invalid_attrs %{rating: nil, user_id: 1}

  def fixture(:vote) do
    {:ok, vote} = Wippli.create_or_update_vote(1,1,1)
    vote
  end

  setup %{conn: conn} do
    insert(:user)
    insert(:zone)
    insert(:song)
    insert(:request)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create vote" do
    test "renders vote when data is valid", %{conn: conn} do
      conn = post conn,"/api/requests/1/" , @create_attrs
      assert response(conn, :created)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, "/api/requests/1/", @invalid_attrs
      assert response(conn, :created)
    end
  end

  describe "update vote" do
    setup [:create_vote]

    test "renders vote when data is valid", %{conn: conn} do
      conn = post conn, "/api/requests/1/", @update_attrs
      assert response(conn, :accepted)

    end


  end

  defp create_vote(_) do
    vote = fixture(:vote)
    {:ok, vote: vote}
  end
end
