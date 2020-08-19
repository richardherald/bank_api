defmodule BankApiWeb.TransactionController do
  use BankApiWeb, :controller

  alias BankApi.Transactions.Transactions

  action_fallback BankApiWeb.FallbackController

  def transactions(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, transactions} <- Transactions.run(user.accounts.id, params) do
      render(conn, "show.json", transactions: transactions)
    end
  end
end
