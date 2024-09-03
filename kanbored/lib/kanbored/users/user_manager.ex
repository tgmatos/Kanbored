defmodule Kanbored.UserManager do
  use Guardian, otp_app: :kanbored
  alias Kanbored.Models.User
  alias Kanbored.Repo

  def subject_for_token(%{user_id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :reason}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Repo.get_by(User, user_id: id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
