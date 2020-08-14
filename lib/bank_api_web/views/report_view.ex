defmodule BankApiWeb.ReportView do
  use BankApiWeb, :view

  def render("show.json", %{total: total}) do
    %{
      data: %{
        total: total
      }
    }
  end
end
