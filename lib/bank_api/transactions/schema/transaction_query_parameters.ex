defmodule BankApi.Transactions.Schema.TransactionQueryParameters do
  @moduledoc """
    Transaction Query Parameters
  """
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :start_date, :date
    field :end_date, :date
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:start_date, :end_date])
    |> validate_required([:start_date, :end_date])
  end
end
