defmodule WippliBackendWeb.ZoneControllerTest do
  use WippliBackendWeb.ConnCase

  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Zone

  @create_attrs %{password: "some password"}
  @update_attrs %{password: "some updated password"}
  @invalid_attrs %{password: nil}

  def fixture(:zone) do
    {:ok, zone} = Wippli.create_zone(@create_attrs)
    zone
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all zones", %{conn: conn} do
      conn = get conn, zone_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create zone" do
    test "renders zone when data is valid", %{conn: conn} do
      conn = post conn, zone_path(conn, :create), zone: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, zone_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "password" => "some password"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, zone_path(conn, :create), zone: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update zone" do
    setup [:create_zone]

    test "renders zone when data is valid", %{conn: conn, zone: %Zone{id: id} = zone} do
      conn = put conn, zone_path(conn, :update, zone), zone: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, zone_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "password" => "some updated password"}
    end

    test "renders errors when data is invalid", %{conn: conn, zone: zone} do
      conn = put conn, zone_path(conn, :update, zone), zone: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete zone" do
    setup [:create_zone]

    test "deletes chosen zone", %{conn: conn, zone: zone} do
      conn = delete conn, zone_path(conn, :delete, zone)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, zone_path(conn, :show, zone)
      end
    end
  end

  defp create_zone(_) do
    zone = fixture(:zone)
    {:ok, zone: zone}
  end
end
