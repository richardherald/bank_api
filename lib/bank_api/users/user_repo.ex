defmodule BankApi.Users.UserRepo do
  @moduledoc """
  User repository
  """

  alias BankApi.Repo
  alias BankApi.Users.Schema.User

  @doc """
  Gets a single User.

  ## Examples

      iex> get_user!("0b386772-7397-45be-9a43-3fb12a617bb7")
      %Admin{}

      iex> get_user!("0b386772-7397-45be-9a43-3fb12a617111")
      ** (Ecto.NoResultsError)
  """
  def get_user!(id) do
    Repo.get!(User, id) |> Repo.preload(:accounts)
  end
end
