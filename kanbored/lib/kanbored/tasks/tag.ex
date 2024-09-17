defmodule Kanbored.Tag do
  use Ecto.Schema

  @primary_key {:tag_id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  
  schema "tags" do
    field :tag_name, :string
    belongs_to :project, Project, foreign_key: :project_id, references: :project_id
  end
end
