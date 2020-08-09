defmodule BankApiWeb.UserView do
  use BankApiWeb, :view

  def render("sign_in.json", %{token: token}) do
    %{
      data: %{
        token: token
      }
    }
  end

  def render("sign_up.json", %{user: user, account: account}) do
    %{
      data: %{
        id: user.id,
        email: user.email,
        name: user.name,
        account: %{
          id: account.id,
          balance: account.balance
        }
      }
    }
  end

  def render("get_user.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        email: user.email,
        name: user.name,
        account: %{
          id: user.accounts.id,
          balance: user.accounts.balance
        }
      }
    }
  end
end
