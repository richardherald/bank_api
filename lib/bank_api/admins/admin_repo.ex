defmodule BankApi.Admins.AdminRepo do
  @moduledoc """
  Admin repository
  """

  alias BankApi.Admins.Schema.Admin
  alias BankApi.Repo

  @doc """
  Gets a single Admin.

  ## Examples

      iex> get_admin!("0b386772-7397-45be-9a43-3fb12a617bb7")
      %Admin{}

      iex> get_admin!("0b386772-7397-45be-9a43-3fb12a617111")
      ** (Ecto.NoResultsError)
  """
  def get_admin!(id) do
    Repo.get!(Admin, id)
  end
end
