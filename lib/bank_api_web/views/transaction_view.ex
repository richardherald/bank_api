defmodule BankApiWeb.TransactionView do
  use BankApiWeb, :view

  def render("show.json", %{transactions: transactions}) do
    %{
      data: %{
        total: transactions.total,
        transactions: render_many(transactions.result, __MODULE__, "transaction.json")
      }
    }
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      account_from_id: transaction.account_from_id,
      account_to_id: transaction.account_to_id,
      type: transaction.type,
      date: transaction.inserted_at,
      value: transaction.value
    }
  end
end
