defmodule BankApi.Admins.Schema.Admin do
  @moduledoc """
  Admin schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "admins" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(admin, params \\ %{}) do
    admin
    |> cast(params, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/, message: "Email format invalid")
    |> validate_length(:password,
      min: 4,
      max: 10,
      message: "Password must be between 4 and 10 characters"
    )
    |> validate_confirmation(:password, message: "Passwords are different")
    |> unique_constraint(:email, message: "Email already used")
    |> put_password()
  end

  defp put_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
  end

  defp put_password(changeset), do: changeset
end
