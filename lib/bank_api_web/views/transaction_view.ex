defmodule BankApiWeb.TransactionView do
  use BankApiWeb, :view

  def render("show.json", %{transactions: transactions}) do
    %{
      data: %{
        total_withdraw: transactions.total_withdraw,
        total_deposit: transactions.total_deposit,
        transactions: render_many(transactions.result, __MODULE__, "transaction.json")
      }
    }
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      account_from_id: convert_uuid(transaction.account_from_id),
      account_to_id: convert_uuid(transaction.account_to_id),
      type: transaction.type,
      date: transaction.inserted_at,
      value: transaction.value
    }
  end

  defp convert_uuid(value) when is_nil(value), do: nil

  defp convert_uuid(value) do
    {:ok, uuid} = Ecto.UUID.cast(value)
    uuid
  end
end
