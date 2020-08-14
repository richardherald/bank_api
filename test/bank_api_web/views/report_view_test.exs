defmodule BankApiWeb.ReportViewTest do
  use ExUnit.Case, async: true

  alias BankApiWeb.ReportView

  test "render/2 returns ok" do
    assert %{data: %{total: 100}} = ReportView.render("show.json", %{total: 100})
  end
end
