defmodule WippliBackend.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias WippliBackend.Repo

  alias WippliBackend.Accounts.User

  def list_users do
    Repo.all(User) |> Repo.preload([:zones, :participants])
  end

  def get_simple_user!(id) do
    Repo.get!(User, id)
  end

  def get_simple_user_by_telegram_id(telegram_id) do
    Repo.get_by(User, telegram_id: telegram_id )
  end
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload([:zones, :participants])
  end


  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end


end
