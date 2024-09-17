defmodule Kanbored.TaskType do
  alias Kanbored.Project
  use Ecto.Schema
  #import Ecto.Changeset

  @primary_key {:task_type_id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "task_types" do
    field :task_type_name, :string
    field :task_type_description, :string
    belongs_to :project, Project, foreign_key: :project_id, references: :project_id
  end
end
