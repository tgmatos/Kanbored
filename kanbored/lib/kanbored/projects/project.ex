defmodule Kanbored.Project do
  alias Kanbored.{User, Board, UserProject, TaskType}
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:project_id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
    
  schema "projects" do
    field :project_name, :string
    field :description, :string
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime

    belongs_to :owner, User, foreign_key: :owner_id, references: :user_id
    has_many :boards, Board, foreign_key: :project_id
    has_many :task_types, TaskType, foreign_key: :project_id
    many_to_many :users, User,
      join_through: UserProject,
      join_keys: [project_id: :project_id, user_id: :user_id]
  end

  def create_project_changeset(project, params \\ %{}) do
    project
    |> cast(params, [:project_name, :description, :owner_id, :updated_at])
    |> validate_required([:project_name, :owner_id])
  end
end
