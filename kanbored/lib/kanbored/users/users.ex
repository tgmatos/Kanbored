defmodule Kanbored.Users do
  alias Kanbored.Models.User
  alias Kanbored.Repo

  def register(attr \\ %{}) do
    insert_result =
      %User{}
      |> User.register_changeset(attr)
      |> Repo.insert()

    case insert_result do
      {:ok, user} ->
        {:ok, user}

      {:error, result_errors} ->
        result_errors.errors
        |> Enum.map(fn {_, {error, _}} -> error end)
    end
  end

  def login(%{email: email, plain_password: plain_password}) do
    with user when not is_nil(user) <- Repo.get_by(User, email: email),
         true <- Argon2.verify_pass(plain_password, user.password) do
      {_, token, _} = Kanbored.UserManager.encode_and_sign(user)
      {:ok, token}
    else
      error when error in [nil, false] -> {:error, :unauthorized}
    end
  end
end
