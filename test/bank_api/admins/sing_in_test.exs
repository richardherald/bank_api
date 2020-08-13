defmodule BankApi.SignInAdminTest do
  use BankApi.DataCase, async: true

  import BankApi.Factory

  alias BankApi.Admins.Schema.Admin
  alias BankApi.Admins.SignIn

  describe "run/2" do
    setup do
      insert(:admin)
      :ok
    end

    test "returns ok when email and password match" do
      assert {:ok, %Admin{}} = SignIn.run("admin@gmail.com", "123456")
    end

    test "returns error when username is invalid" do
      assert {:error, "username or password invalid"} = SignIn.run("admingmail.com", "123456")
    end

    test "returns error when password is invalid" do
      assert {:error, "username or password invalid"} = SignIn.run("admin@gmail.com", "12345")
    end
  end
end
