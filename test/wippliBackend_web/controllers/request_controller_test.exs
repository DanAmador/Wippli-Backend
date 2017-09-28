defmodule WippliBackendWeb.RequestControllerTest do
  use WippliBackendWeb.ConnCase

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Request

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:request) do
    {:ok, request} = Wippli.create_request(@create_attrs)
    request
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all requests", %{conn: conn} do
      conn = get conn, request_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create request" do
    test "renders request when data is valid", %{conn: conn} do
      conn = post conn, request_path(conn, :create), request: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, request_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, request_path(conn, :create), request: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update request" do
    setup [:create_request]

    test "renders request when data is valid", %{conn: conn, request: %Request{id: id} = request} do
      conn = put conn, request_path(conn, :update, request), request: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, request_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, request: request} do
      conn = put conn, request_path(conn, :update, request), request: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete request" do
    setup [:create_request]

    test "deletes chosen request", %{conn: conn, request: request} do
      conn = delete conn, request_path(conn, :delete, request)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, request_path(conn, :show, request)
      end
    end
  end

  defp create_request(_) do
    request = fixture(:request)
    {:ok, request: request}
  end
end
