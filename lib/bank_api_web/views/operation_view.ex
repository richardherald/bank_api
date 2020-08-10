defmodule BankApiWeb.OperationView do
  use BankApiWeb, :view

  def render("transfer.json", %{}) do
    %{
      status: "ok"
    }
  end

  def render("withdraw.json", %{}) do
    %{
      status: "ok"
    }
  end
end
