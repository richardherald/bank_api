defmodule BankApiWeb.AuthUserAccessPipeline do
  @moduledoc """
  Pipeline User Authorization module
  """
  use Guardian.Plug.Pipeline, otp_app: :bank_api

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
