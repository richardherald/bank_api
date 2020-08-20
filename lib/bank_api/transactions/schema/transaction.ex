defmodule BankApi.Transactions.Schema.Transaction do
  @moduledoc """
  Transaction schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID
  schema "transactions" do
    belongs_to :account, BankApi.Users.Schema.Account, foreign_key: :account_id
    field :value, :integer
    field :type, :string
    field :transaction_link_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(transaction, params \\ %{}) do
    transaction
    |> cast(params, [:value, :type, :transaction_link_id])
    |> cast_assoc(:account, required: true)
    |> validate_required([:value, :type, :account])
  end
end
