defmodule BankApiWeb.OperationController do
  use BankApiWeb, :controller

  alias BankApi.Operations.Transfer
  alias BankApiWeb.Guardian

  action_fallback BankApiWeb.FallbackController

  def transfer(conn, %{"to" => to_id, "value" => value}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, _, _} <- Transfer.run(user.accounts.id, to_id, value) do
      render(conn, "transfer.json", %{})
    end
  end
end
