defmodule Kanbored.UserProject do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kanbored.{User, Project}

  @primary_key false
  @foreign_key_type :binary_id

  schema "users_projects" do
    belongs_to :user, User, references: :user_id, primary_key: true
    belongs_to :project, Project, references: :project_id, primary_key: true
  end

  def changeset(user_project, params \\ %{}) do
    user_project
    |> cast(params, [:user_id, :project_id])
    |> validate_required([:user_id, :project_id])
    |> unique_constraint([:user_id, :email_id], name: "users_projects_pkey")
  end
end
