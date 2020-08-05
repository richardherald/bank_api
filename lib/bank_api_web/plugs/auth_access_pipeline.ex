defmodule BankApiWeb.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :bank_api

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
