defmodule BankApiWeb.UserViewTest do
  use ExUnit.Case, async: true

  alias BankApiWeb.UserView

  test "render/2 returns ok and the user data" do
    assert %{status: "ok", data: %{token: "123"}} =
             UserView.render("sign_in.json", %{token: "123"})
  end
end
