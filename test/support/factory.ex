defmodule BankApi.Factory do
  @moduledoc """
  Factory module
  """
  use ExMachina.Ecto, repo: BankApi.Repo

  alias BankApi.Users.Schema.User

  def user_factory do
    %User{
      name: "Richard",
      email: "Richard@gmail.com",
      password: "123456",
      password_confirmation: "123456",
      password_hash: Bcrypt.hash_pwd_salt("123456")
    }
  end
end
