defmodule BankApi.Users.GetUser do
  @moduledoc """
  SignIn module
  """
  alias BankApi.Repo
  alias BankApi.Users.Schema.User

  @doc """
  Gets a single User.

  ## Examples

      iex> run("0b386772-7397-45be-9a43-3fb12a617bb7")
      %User{}

      iex> run("0b386772-7397-45be-9a43-3fb12a617111")
      nil
  """
  def run(id), do: Repo.get(User, id) |> Repo.preload(:accounts)
end
