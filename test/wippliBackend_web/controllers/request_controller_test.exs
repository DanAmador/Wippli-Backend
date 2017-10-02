defmodule WippliBackendWeb.RequestControllerTest do
  use WippliBackendWeb.ConnCase

  import Wippli.Factory
  alias WippliBackend.Wippli

  @create_attrs %{
    user_id: 1,
    song_url: "https://youtu.be/PLIJc7YE_jw"
  }

  @invalid_attrs %{
    user_id: 1,
    song_url: "not a link"
  }

  def fixture(:request) do
    {:ok, request} = Wippli.create_request(@create_attrs)
    request
  end

  setup %{conn: conn} do
    insert(:user)
    insert(:zone)
#    insert(:song)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create request" do
    test "renders request when data is valid", %{conn: conn} do
      conn = post conn,"/api/zones/1/requests/" , @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, request_path(conn, :show, id)
      assert json_response(conn, 200) == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, "/api/zones/1/requests/",  @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
