defmodule WippliBackend.WippliTest do
  use WippliBackend.DataCase

  alias WippliBackend.Wippli

  describe "zones" do
    alias WippliBackend.Wippli.Zone

    @user_rel %WippliBackend.Accounts.User{phone: "5555555555", id: 1}
    @valid_attrs %{password: "some password"}
    @update_attrs %{password: "some updated password"}
    @invalid_attrs %{password: nil}

    def zone_fixture(attrs \\ %{}) do
      {:ok, zone} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wippli.create_zone(@user_rel)

      zone
    end

    test "list_zones/0 returns all zones" do
      zone = zone_fixture()
      assert Wippli.list_zones() == [zone]
    end

    test "get_zone!/1 returns the zone with given id" do
      zone = zone_fixture()
      assert Wippli.get_zone!(zone.id) == zone
    end

    test "create_zone/1 with valid data creates a zone" do
      assert {:ok, %Zone{} = zone} = Wippli.create_zone(@valid_attrs,@user_rel)
      assert zone.password == "some password"
    end

    test "create_zone/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wippli.create_zone(@invalid_attrs, @user_rel)
    end

    test "update_zone/2 with valid data updates the zone" do
      zone = zone_fixture()
      assert {:ok, zone} = Wippli.update_zone(zone, @update_attrs, @user_rel)
      assert %Zone{} = zone
      assert zone.password == "some updated password"
    end

    test "update_zone/2 with invalid data returns error changeset" do
      zone = zone_fixture()
      assert {:error, %Ecto.Changeset{}} = Wippli.update_zone(zone, @invalid_attrs, @user_rel)
      assert zone == Wippli.get_zone!(zone.id)
    end

    test "delete_zone/1 deletes the zone" do
      zone = zone_fixture()
      assert {:ok, %Zone{}} = Wippli.delete_zone(zone)
      assert_raise Ecto.NoResultsError, fn -> Wippli.get_zone!(zone.id) end
    end

    test "change_zone/1 returns a zone changeset" do
      zone = zone_fixture()
      assert %Ecto.Changeset{} = Wippli.change_zone(zone)
    end
  end

  describe "participant" do
    alias WippliBackend.Wippli.Participants

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def participants_fixture(attrs \\ %{}) do
      {:ok, participants} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wippli.create_participants()

      participants
    end

    test "list_participant/0 returns all participant" do
      participants = participants_fixture()
      assert Wippli.list_participant() == [participants]
    end

    test "get_participants!/1 returns the participants with given id" do
      participants = participants_fixture()
      assert Wippli.get_participants!(participants.id) == participants
    end

    test "create_participants/1 with valid data creates a participants" do
      assert {:ok, %Participants{} = participants} = Wippli.create_participants(@valid_attrs)
    end

    test "create_participants/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wippli.create_participants(@invalid_attrs)
    end

    test "update_participants/2 with valid data updates the participants" do
      participants = participants_fixture()
      assert {:ok, participants} = Wippli.update_participants(participants, @update_attrs)
      assert %Participants{} = participants
    end

    test "update_participants/2 with invalid data returns error changeset" do
      participants = participants_fixture()
      assert {:error, %Ecto.Changeset{}} = Wippli.update_participants(participants, @invalid_attrs)
      assert participants == Wippli.get_participants!(participants.id)
    end

    test "delete_participants/1 deletes the participants" do
      participants = participants_fixture()
      assert {:ok, %Participants{}} = Wippli.delete_participants(participants)
      assert_raise Ecto.NoResultsError, fn -> Wippli.get_participants!(participants.id) end
    end

    test "change_participants/1 returns a participants changeset" do
      participants = participants_fixture()
      assert %Ecto.Changeset{} = Wippli.change_participants(participants)
    end
  end
end
