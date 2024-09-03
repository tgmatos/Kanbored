defmodule Kanbored.Models.Board do
  alias Kanbored.Models.Project
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:board_id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "boards" do
    field :board_name, :string
    belongs_to :project, Project, foreign_key: :project_id, references: :project_id
  end

  def changeset(board, attr \\ %{}) do
    board
    |> cast(attr, [:board_name, :project_id])
  end
end
