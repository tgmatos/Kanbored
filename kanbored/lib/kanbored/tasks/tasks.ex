defmodule Kanbored.Tasks do
  alias Ecto.Multi
  alias Kanbored.Board
  alias Kanbored.Project
  alias Kanbored.Repo
  alias Kanbored.Task
  alias Kanbored.UserProject
  import Ecto.Query

  def create_task(attr \\ %{}) do
    %Task{}
    |> Task.changeset(attr)
    |> Repo.insert()
    |> case do
      {:ok, result} -> {:ok, result}
      {:error, result_error} -> result_error |> Enum.map(fn {_, {error, _}} -> error end)
    end
  end
  
  def get_tasks_by_project(%{project_id: project_id, user_id: user_id}) do
    case Repo.exists?(UserProject, [project_id: project_id, user_id: user_id]) do
      false -> {:error, :user_not_found_in_project}
      true -> from(t in Task,
         join: b in Board, on: b.board_id == t.board_id,
         join: p in Project, on: p.project_id == b.project_id,
         where: p.project_id == ^project_id
    ) |> Repo.all
    end
  end

  # Talvez fazer mais coisas
  def remove_task(%{project_id: project_id, task_id: task_id, user_id: user_id}) do
    Multi.new()
    |> Multi.run(:check_user, fn repo, _changes ->
      check_user_in_project(repo, %{project_id: project_id, user_id: user_id})
    end)
    |> Multi.delete_all(:delete_task, from(t in Task, where: t.task_id == ^task_id))
    |> Repo.transaction()
  end

  defp check_user_in_project(repo, %{project_id: project_id, user_id: user_id}) do
    case repo.exists?(UserProject, project_id: project_id, user_id: user_id) do
      false -> {:error, :user_not_found_on_project}
      true -> {:ok, true}
    end
  end
end
