defmodule BankApi.SignInTest do
  use BankApi.DataCase, async: true

  import BankApi.Factory

  alias BankApi.Users.Schema.User
  alias BankApi.Users.SignIn

  describe "run/2" do
    setup do
      insert(:user)
      :ok
    end

    test "returns ok when email and password match" do
      assert {:ok, %User{}} = SignIn.run("Richard@gmail.com", "123456")
    end

    test "returns error when username is invalid" do
      assert {:error, :username_password_invalid} = SignIn.run("Richardgmail.com", "123456")
    end

    test "returns error when password is invalid" do
      assert {:error, :username_password_invalid} = SignIn.run("Richardgmail.com", "123456")
    end
  end
end
