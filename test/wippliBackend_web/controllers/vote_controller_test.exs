defmodule WippliBackendWeb.VoteControllerTest do
  use WippliBackendWeb.ConnCase

  import Wippli.Factory
  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Vote

  @create_attrs %{rating: 42, user_id: 1, zone_id: 1, request_id: 1}
  @update_attrs %{rating: 404040, user_id: 1, zone_id: 1, request_id: 1}
  @invalid_attrs %{rating: nil, user_id: 1, zone_id: 1, request_id: 1}

  def fixture(:vote) do
    {:ok, vote} = Wippli.create_vote(1,1,1)
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
      assert %{"id" => id} = json_response(conn, 201)

      assert json_response(conn, 201) == %{
        "id" => id,
        "rating" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, "/api/requests/1/", @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update vote" do
    setup [:create_vote]

    test "renders vote when data is valid", %{conn: conn, vote: %Vote{id: id} = vote} do
      conn = put conn, "/api/requests/1/1",@update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get conn, "/api/requests/1/1"
      assert json_response(conn, 200) == %{
        "id" => id,
        "rating" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, vote: vote} do
      conn = put conn, "/api/requests/1/1",  @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete vote" do
    setup [:create_vote]

    test "deletes chosen vote", %{conn: conn, vote: vote} do
      conn = delete conn, "/api/requests/1/1"
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, vote_path(conn, :show, vote)
      end
    end
  end

  defp create_vote(_) do
    vote = fixture(:vote)
    {:ok, vote: vote}
  end
end
