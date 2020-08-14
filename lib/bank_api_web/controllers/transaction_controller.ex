defmodule BankApiWeb.TransactionController do
  use BankApiWeb, :controller

  alias BankApi.Transactions.Transactions

  action_fallback BankApiWeb.FallbackController

  def transactions(conn, %{"start_date" => start_date, "end_date" => end_date}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, transactions} <- Transactions.run(user.accounts.id, start_date, end_date) do
      render(conn, "show.json", transactions: transactions)
    end
  end
end
