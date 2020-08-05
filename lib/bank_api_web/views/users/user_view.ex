defmodule BankApiWeb.UserView do
  use BankApiWeb, :view

  def render("sign_in.json", %{token: token}) do
    %{
      status: "ok",
      data: %{
        token: token
      }
    }
  end
end
