defmodule BankApiWeb.FallbackController do
  use BankApiWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankApiWeb.ErrorView)
    |> render("error_changeset.json", changeset: changeset)
  end

  def call(conn, {:error, message}) do
    conn
    |> put_status(401)
    |> put_view(BankApiWeb.ErrorView)
    |> render("error_message.json", message: message)
  end
end
