defmodule BankApi.Users.Schema.Account do
  @moduledoc """
  Account schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID
  schema "accounts" do
    field :balance, :integer, default: 100000
    belongs_to :users, BankApi.Users.Schema.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:balance])
    |> validate_required([:balance])
  end
end
