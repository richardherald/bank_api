defmodule BankApiWeb.AdminViewTest do
  use ExUnit.Case, async: true

  alias BankApiWeb.AdminView

  describe "render/2" do
    test "returns ok and admin data" do
      admin = %{
        id: "123",
        email: "admin@gmail.com",
        password: "123456",
        password_confirmation: "123456"
      }

      assert %{data: %{email: "admin@gmail.com", id: "123"}} =
               AdminView.render("sign_up.json", %{admin: admin})
    end
  end
end
