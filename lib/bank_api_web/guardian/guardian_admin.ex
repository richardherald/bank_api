defmodule BankApiWeb.GuardianAdmin do
  @moduledoc """
  Guardian Admin module
  """
  use Guardian, otp_app: :bank_api

  alias BankApi.Admins.AdminRepo

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    user = AdminRepo.get_admin!(claims["sub"])
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :unauthorized}
  end
end
