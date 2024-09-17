defmodule Kanbored.Task do
  alias Kanbored.{Board, User}
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:task_id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "tasks" do
    field :task_name, :string
    field :description, :string
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :priority, Ecto.Enum, values: [:LOW, :NORMAL, :HIGH, :URGENT]
    field :due_date, :date

    belongs_to :board, Board, foreign_key: :board_id, references: :board_id
    belongs_to :user, User, foreign_key: :user_id, references: :user_id
  end

  def changeset(task, params \\ %{}) do
    task
    |> cast(params, [:task_name, :description, :board_id, :priority, :due_date, :user_id])
    |> validate_required([:task_name, :board_id, :project_id, :user_id])
  end
end
