defmodule WippliBackend.WippliTest do
  use WippliBackend.DataCase

  alias WippliBackend.Wippli

  describe "requests" do
    alias WippliBackend.Wippli.Request

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def request_fixture(attrs \\ %{}) do
      {:ok, request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wippli.create_request()

      request
    end

    test "list_requests/0 returns all requests" do
      request = request_fixture()
      assert Wippli.list_requests() == [request]
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()
      assert Wippli.get_request!(request.id) == request
    end

    test "create_request/1 with valid data creates a request" do
      assert {:ok, %Request{} = request} = Wippli.create_request(@valid_attrs)
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wippli.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()
      assert {:ok, request} = Wippli.update_request(request, @update_attrs)
      assert %Request{} = request
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = Wippli.update_request(request, @invalid_attrs)
      assert request == Wippli.get_request!(request.id)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = Wippli.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> Wippli.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = Wippli.change_request(request)
    end
  end
end
