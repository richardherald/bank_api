defmodule BankApi.Users.Schema.Account do
  @moduledoc """
  Account schema
  """
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID
  schema "accounts" do
    field :balance, :decimal, precision: 10, scale: 2, default: 1000
    belongs_to :users, BankApi.Users.Schema.User

    timestamps()
  end
end
