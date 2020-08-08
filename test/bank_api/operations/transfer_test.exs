defmodule BankApi.TransferTest do
  use BankApi.DataCase, async: true

  import BankApi.Factory

  alias BankApi.Operations.Transfer

  describe "run/3" do
    test "returns struct when transfer is completed successfully" do
      account_from = insert(:user)
      account_to = insert(:user, email: "ygor@gmail.com")

      {:ok, from, to} = Transfer.run(account_from.accounts.id, account_to.accounts.id, 100)

      assert from.balance == 900
      assert to.balance == 1100
    end

    test "returns error when the balance is insufficient for transfer" do
      account_from = insert(:user)
      account_to = insert(:user, email: "ygor@gmail.com")

      {:error, :insufficient_funds} =
        Transfer.run(account_from.accounts.id, account_to.accounts.id, 1200)
    end

    test "returns error when the account from is not found" do
      account_to = insert(:user, email: "ygor@gmail.com")

      {:error, :account_not_found} =
        Transfer.run("0b386772-7397-45be-9a43-3fb12a617bb2", account_to.accounts.id, 100)
    end

    test "returns error when the account to is not found" do
      account_from = insert(:user)

      {:error, :account_not_found} =
        Transfer.run(account_from.accounts.id, "0b386772-7397-45be-9a43-3fb12a617bb2", 100)
    end
  end
end