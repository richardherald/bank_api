defmodule BankApi.Users.Schema.User do
    @moduledoc """
  User schema
  """
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    has_one :accounts, BankApi.Users.Schema.Account

    timestamps()
  end
end
