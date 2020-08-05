defmodule BankApiWeb.UserView do
  use BankApiWeb, :view

  def render("sign_in.json", %{user: user}) do
    %{
      status: "ok",
      data: %{
        name: user.name
      }
    }
  end
end
