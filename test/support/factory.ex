defmodule BankApi.Factory do
  @moduledoc """
  Factory module
  """
  use ExMachina.Ecto, repo: BankApi.Repo

  alias BankApi.Admins.Schema.Admin
  alias BankApi.Transactions.Schema.Transaction
  alias BankApi.Users.Schema.{Account, User}

  def user_factory do
    %User{
      name: "Richard",
      email: "Richard@gmail.com",
      password: "123456",
      password_confirmation: "123456",
      password_hash: Bcrypt.hash_pwd_salt("123456"),
      accounts: build(:account)
    }
  end

  def account_factory do
    %Account{
      balance: 1000
    }
  end

  def transaction_factory do
    %Transaction{
      account: build(:account),
      value: 100,
      type: "withdraw",
      inserted_at: DateTime.utc_now()
    }
  end

  def admin_factory do
    %Admin{
      email: "admin@gmail.com",
      password: "123456",
      password_confirmation: "123456",
      password_hash: Bcrypt.hash_pwd_salt("123456")
    }
  end
end
