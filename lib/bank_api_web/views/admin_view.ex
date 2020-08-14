defmodule BankApiWeb.AdminView do
  use BankApiWeb, :view

  def render("sign_up.json", %{admin: admin}) do
    %{
      data: %{
        id: admin.id,
        email: admin.email
      }
    }
  end

  def render("sign_in.json", %{token: token}) do
    %{
      data: %{
        token: token
      }
    }
  end
end
