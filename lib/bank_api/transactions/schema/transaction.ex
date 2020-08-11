defmodule BankApi.Transactions.Schema.Transaction do
  @moduledoc """
  Account schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID
  schema "transactions" do
    belongs_to :account_from, BankApi.Users.Schema.Account, foreign_key: :account_from_id
    belongs_to :account_to, BankApi.Users.Schema.Account, foreign_key: :account_to_id
    field :value, :integer
    field :date, :date
    field :type, :string

    timestamps()
  end

  def changeset(transaction, params \\ %{}) do
    transaction
    |> cast(params, [:value, :type])
    |> cast_assoc(:account_from, required: true)
    |> cast_assoc(:account_to, required: false)
    |> validate_required([:value, :type, :account_from])
  end
end
