defmodule BankApi.Factory do
  @moduledoc """
  Factory module
  """
  use ExMachina.Ecto, repo: BankApi.Repo

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
end
