defmodule BankApiWeb.UserViewTest do
  use ExUnit.Case, async: true

  alias BankApiWeb.UserView

  import BankApi.Factory

  describe "render/2" do
    test "returns ok and token" do
      assert %{data: %{token: "123"}} = UserView.render("sign_in.json", %{token: "123"})
    end

    test "returns ok and user data" do
      user = %{
        id: "123",
        name: "Richard",
        email: "Richard@gmail.com",
        password: "123456",
        password_confirmation: "123456",
        account: %{
          id: "123",
          balance: "1000"
        }
      }

      assert user = UserView.render("sign_up.json", %{user: user, account: user.account})
    end
  end
end
