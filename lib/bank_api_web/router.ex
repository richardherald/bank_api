defmodule BankApiWeb.Router do
  use BankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug BankApiWeb.AuthAccessPipeline
  end

  scope "/api/v1", BankApiWeb do
    pipe_through :api

    post "/sign_in", UserController, :sign_in
  end

  scope "/api/v1", BankApiWeb do
    pipe_through :api_auth

    get "/users/:id", UserController, :get_user

    post "/operations/transfer", OperationController, :transfer
  end
end
