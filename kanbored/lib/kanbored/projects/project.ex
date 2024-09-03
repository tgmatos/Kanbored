defmodule Kanbored.Models.Project do
  alias Kanbored.Models.{User, Board, UserProject}
  use Ecto.Schema
  import Ecto.{Schema, Changeset}

  @primary_key {:project_id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "projects" do
    field :project_name, :string
    field :description, :string
    belongs_to :owner, User, foreign_key: :owner_id, references: :user_id
    has_many :board, Board, foreign_key: :project_id

    many_to_many :users, User,
      join_through: UserProject,
      join_keys: [project_id: :project_id, user_id: :user_id]
  end

  def create_project_changeset(project, params \\ %{}) do
    project
    |> cast(params, [:project_name, :description, :owner_id])
    |> validate_required([:project_name, :owner_id])
  end
end
