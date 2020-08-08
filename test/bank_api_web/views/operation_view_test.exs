defmodule BankApiWeb.OperationViewTest do
  use ExUnit.Case, async: true

  alias BankApiWeb.OperationView

  test "render/2 returns ok" do
    assert %{status: "ok"} = OperationView.render("transfer.json", %{})
  end
end
