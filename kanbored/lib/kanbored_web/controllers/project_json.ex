defmodule KanboredWeb.ProjectJSON do
  require Logger

  def new_project(%{msg: msg}) do
    %{
      name: msg.project_name,
      description: msg.description
    }
  end

  def delete_project(conn) do
    %{result: :ok}
  end

  def add_user_to_project(%{msg: msg}) do
    %{
      project: msg.project_id,
      user: msg.user_id
    }
  end

  def add_user_to_project(%{project_id: project_id, result: result}) do
    %{
      project: project_id,
      users:
        result
        |> Enum.filter(fn entry ->
          case entry do
            {:ok, _} -> true
            {:error, _} -> false
          end
        end)
        |> Enum.map(fn entry ->
          {:ok, %{user_id: id}} = entry
          id
        end)
    }
  end

  def remove_user_from_project(%{result: result}) do
    %{
      project: Map.get(result, :project_id),
      user: Map.get(result, :user_id)
    }
  end
  
  def project_not_found(_conn) do
    %{error: %{reason: "Project not found"}}
  end

  def not_owner(_conn) do
    %{error: %{reason: "You are not the owner of the project"}}
  end
end
