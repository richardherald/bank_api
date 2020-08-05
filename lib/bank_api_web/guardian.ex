defmodule BankApiWeb.Guardian do
  @moduledoc """
  Guardian module
  """
  use Guardian, otp_app: :bank_api

  alias BankApi.Users.UserRepo

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    user = UserRepo.get_user!(claims["sub"])
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :unauthorized}
  end
end
