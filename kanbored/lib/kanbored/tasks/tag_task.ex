defmodule Kanbored.TagTask do
  use Ecto.Schema
  import Kanbored.{Tag, Task}
  
  @primary_key false
  @foreign_key_type :binary_id
  
  schema "tags_tasks" do
    belongs_to :tag, Tag, references: :tag_id, primary_key: true
    belongs_to :task, Task, references: :task_id, primary_key: true
  end
end
