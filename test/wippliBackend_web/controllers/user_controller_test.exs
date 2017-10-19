defmodule WippliBackendWeb.UserControllerTest do
  use WippliBackendWeb.ConnCase

  alias WippliBackend.Accounts
  alias WippliBackend.Accounts.User

  @create_attrs %{
    nickname: "Metrosexual Fruitcake",
    phone: "some phone", telegram_id: 1}
  @update_attrs %{
    nickname: "Metrosexual Fruitcake",
    phone: "some updated phone"}
  @invalid_attrs %{nickname: nil, phone: nil, telegram_id: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] != []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "nickname" => "Metrosexual Fruitcake",
        "phone" => "some phone",
        "created_zones" => [],
        "participates_in" => nil,
        "telegram_id" => 1}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "nickname" => "Metrosexual Fruitcake",
        "phone" => "some updated phone",
        "created_zones" => [],
        "participates_in" => nil,
        "telegram_id" => 1}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)

    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
