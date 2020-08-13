defmodule BankApiWeb.FallbackController do
  use BankApiWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankApiWeb.ErrorView)
    |> render("error_changeset.json", changeset: changeset)
  end

  def call(conn, message) when is_nil(message) do
    conn
    |> put_status(:not_found)
    |> put_view(BankApiWeb.ErrorView)
    |> render("error_message.json", message: "Not found")
  end

  def call(conn, {:error, message}) when message == :transfer_your_own_account do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankApiWeb.ErrorView)
    |> render("error_message.json", message: "You cannot transfer to your own account")
  end

  def call(conn, {:error, message}) when message == :insufficient_balance do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankApiWeb.ErrorView)
    |> render("error_message.json",
      message: "You don't have enough balance to perform this operation"
    )
  end

  def call(conn, {:error, message}) when message == :negative_value do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankApiWeb.ErrorView)
    |> render("error_message.json",
      message: "The value cannot be negative"
    )
  end

  def call(conn, {:error, message}) when message == :account_not_found do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankApiWeb.ErrorView)
    |> render("error_message.json", message: "Account not found")
  end

  def call(conn, {:error, message}) when message == :invalid_date_format do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankApiWeb.ErrorView)
    |> render("error_message.json",
      message:
        "Invalid date format. Check that parameters start_date or end_date are in the format yyyy-MM-dd"
    )
  end

  def call(conn, {:error, message}) do
    conn
    |> put_status(401)
    |> put_view(BankApiWeb.ErrorView)
    |> render("error_message.json", message: message)
  end
end
