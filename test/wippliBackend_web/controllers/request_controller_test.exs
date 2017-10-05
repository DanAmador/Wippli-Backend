defmodule WippliBackendWeb.RequestControllerTest do
  use WippliBackendWeb.ConnCase

  import Wippli.Factory
  alias WippliBackend.Wippli

  @create_attrs %{
    user_id: 1,
    song_url: "https://youtu.be/PLIJc7YE_jw"
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
      assert %{"id" => _} = json_response(conn, 201)
    end
  end
end
