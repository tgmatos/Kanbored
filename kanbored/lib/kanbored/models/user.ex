defmodule Kanbored.Models.User do
  use Ecto.Schema
  alias Kanbored.Models.{Project, UserProject}
  import Ecto.Changeset
  import EctoCommons.EmailValidator

  @primary_key {:user_id, :binary_id, autogenerate: false}

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, redact: true
    field :plain_password, :string, virtual: true, redact: true

    many_to_many :project, Project,
      join_through: UserProject,
      join_keys: [user_id: :user_id, project_id: :project_id]

    # field :profile_picture, :binary
  end

  def register_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :email, :plain_password])
    |> validate_required([:username, :email, :plain_password])
    |> validate_email(:email)
    |> unique_constraint([:username, :email], name: "users_username_key")
    |> register_validate_password()
  end

  def register_validate_password(changeset) do
    changeset
    |> validate_length(:plain_password, min: 6, max: 256)
    |> validate_format(:plain_password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:plain_password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:plain_password, ~r/[!?@#$%^&*_0-9]/,
      message: "at least one digit or punctuation character"
    )
    |> hash_password
  end

  def hash_password(changeset) do
    case Map.get(changeset, :errors) do
      [] ->
        %{changes: %{plain_password: plain_password}} = changeset

        changes =
          changeset
          |> Map.get(:changes)
          |> Map.put(:password, Argon2.hash_pwd_salt(plain_password))

        Map.put(changeset, :changes, changes)

      _ ->
        changeset
    end
  end
end
