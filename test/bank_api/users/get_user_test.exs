defmodule BankApi.GetUserTest do
  use BankApi.DataCase, async: true

  import BankApi.Factory

  alias BankApi.Users.GetUser

  describe "run/1" do
    test "returns struct when user found" do
      users = insert(:user)
      user = GetUser.run(users.id)

      assert user.name == "Richard"
      assert user.email == "Richard@gmail.com"
      refute user.password_hash == "123456"

      assert user.accounts.balance == 100_000
    end

    test "returns nil when user not found" do
      insert(:user)
      user = GetUser.run("c692b120-6d66-40ff-b0c7-50baa50fa342")

      assert user == nil
    end
  end
end
