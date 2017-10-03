defmodule WippliBackendWeb.ZoneControllerTest do
  use WippliBackendWeb.ConnCase

  import Wippli.Factory
  alias WippliBackend.Wippli
  alias WippliBackend.Wippli.Zone


  @create_attrs %{password: "some password"}
  @update_attrs %{old_password: "some password", new_password: "some updated password", user_id: 1}
  @invalid_attrs %{password: nil}
  @invalid_update_attrs %{new_password: nil, old_password: nil, user_id: 1}
  @invalid_user_update %{new_password: "new password", old_password: "some password", user_id: 2}
  @invalid_pass_update %{new_password: "hello", old_password: "false password", user_id: 1}

  def fixture(:zone) do
    {:ok, zone} = Wippli.create_zone(@create_attrs, 1)
    zone
  end
  setup %{conn: conn} do

    insert(:user)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all zones", %{conn: conn} do
      conn = get conn, zone_path(conn, :index)
      assert json_response(conn, 200) == []
    end
  end

  describe "create zone" do
    test "renders zone when data is valid", %{conn: conn} do
      conn = post conn, zone_path(conn, :create), %{zone: @create_attrs, user_id: 1}
      assert %{"id" => id} = json_response(conn, 201)

      conn = get conn, zone_path(conn, :show, id)
      resp = json_response(conn, 200)
      participants = resp["participants"]
      assert resp == %{
        "id" => id,
        "password" => "some password",
        "requests" => [],
        "participants" => participants,
        "updated_at" => resp["updated_at"],
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, zone_path(conn, :create), %{zone: @invalid_attrs, user_id: 1}
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update zone" do
    setup [:create_zone]

    test "renders zone when data is valid", %{conn: conn, zone: %Zone{id: id} = zone} do
      conn = put conn, zone_path(conn, :update, zone), @update_attrs

      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get conn, zone_path(conn, :show, id)
      resp = json_response(conn, 200)
      assert resp == %{
        "id" => id,
        "password" => "some updated password",
        "participants" => [],
        "requests" => [],
        "updated_at" => resp["updated_at"]
      }
    end

   test "renders errors when data is invalid", %{conn: conn, zone: zone} do
      conn = put conn, zone_path(conn, :update, zone), @invalid_update_attrs
      assert json_response(conn, 500)["errors"] != %{}
    end

    test "renders errors when user is invalid", %{conn: conn, zone: zone } do
      conn = put conn, zone_path(conn, :update, zone), @invalid_user_update
      assert json_response(conn, 403)["errors"] == "Action forbidden: User didn't create this zone"
    end

    test "renders error when password is invalid", %{conn: conn, zone: zone} do
      conn = put conn, zone_path(conn, :update, zone), @invalid_pass_update
      assert json_response(conn, 500)["errors"] == "Internal server error: Passwords don't match"
    end
  end

  describe "delete zone" do
    setup [:create_zone]

    test "deletes chosen zone", %{conn: conn, zone: zone} do
      conn = delete conn, zone_path(conn, :delete, zone)
      assert response(conn, 204)
    end
  end

    defp create_zone(_) do
    zone = fixture(:zone)
    {:ok, zone: zone}
  end
end
