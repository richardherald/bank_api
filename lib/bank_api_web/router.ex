defmodule BankApiWeb.Router do
  use BankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug BankApiWeb.AuthUserAccessPipeline
  end

  pipeline :api_admin_auth do
    plug BankApiWeb.AuthAdminAccessPipeline
  end

  scope "/api/v1", BankApiWeb do
    pipe_through :api

    post "/sign_in", UserController, :sign_in
    post "/sign_up", UserController, :sign_up
  end

  scope "/api/v1", BankApiWeb do
    pipe_through [:api, :api_auth]

    get "/users/:id", UserController, :get_user

    post "/operations/transfer", OperationController, :transfer
    post "/operations/withdraw", OperationController, :withdraw

    get "/transactions", TransactionController, :transactions
  end

  scope "/api/v1/admin", BankApiWeb do
    pipe_through :api

    post "/sign_up", AdminController, :sign_up
    post "/sign_in", AdminController, :sign_in
  end
end
