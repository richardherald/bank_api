defmodule BankApiWeb.Router do
  use BankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", BankApiWeb do
    pipe_through :api

    post "/sign_in", UserController, :sign_in
  end
end
