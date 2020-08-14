defmodule BankApiWeb.ReportController do
  use BankApiWeb, :controller

  alias BankApi.Admins.Report

  action_fallback BankApiWeb.FallbackController

  def report(conn, params) do
    with {:ok, total} <- Report.run(params) do
      render(conn, "show.json", total: total)
    end
  end
end
