defmodule BankApiWeb.UserViewTest do
  use ExUnit.Case, async: true

  alias BankApiWeb.UserView

  import BankApi.Factory

  test "render/2 returns ok and the user data" do
    user = params_for(:user)

    assert %{status: "ok", data: %{name: "Richard"}} =
             UserView.render("sign_in.json", %{user: user})
  end
end
