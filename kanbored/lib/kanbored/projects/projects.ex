defmodule Kanbored.Projects do
  alias Kanbored.{Repo, Project, Board, UserProject, User, Task, TaskType}
  alias Ecto.Multi
  import Ecto.Query, only: [from: 2]

  def new_project(attr \\ %{}) do
    %Project{}
    |> Project.create_project_changeset(attr)
    |> Repo.insert()
    |> case do
      {:ok, project} -> {:ok, project}
      {:error, result_error} -> result_error.errors |> Enum.map(fn {_, {error, _}} -> error end)
    end
  end

  @spec get_project(%{project_id: String.t(), user_id: String.t()}) ::
          {:ok, %Project{}} | {:error, :user_not_found_in_project | :project_not_found}
  def get_project(%{project_id: project_id, user_id: user_id}) do
    with true <- Repo.exists?(UserProject, user_id: user_id, project_id: project_id),
         {:ok, project} <- get_project_from_cache(project_id) do
      
      {:ok, project}
    else
      false -> {:error, :user_not_found_in_project}
      {:error, :project_not_found} -> {:error, :project_not_found}
    end
  end

  @spec get_project_from_cache(String.t()) ::
          {:ok, %Project{}} | {:error, :project_not_found}
  defp get_project_from_cache(project_id) do
    case Cachex.get(:kanbored_cache, project_id) do
      {:ok, nil} -> get_project_from_repo(project_id)
      {:ok, project} ->
        {:ok, project}
    end
  end

  @spec get_project_from_repo(String.t()) ::
          {:ok, %Project{}} | {:error, :project_not_found}
  defp get_project_from_repo(project_id) do
    case Repo.get_by(Project, project_id: project_id) do
      nil -> {:error, :project_not_found}
      project ->
        Cachex.put(:kanbored_cache, project_id, project)
        {:ok, project}
    end
  end
  
  @spec remove_project(%{project_id: String.t(), owner_id: String.t()}) ::
          {:ok, any()} | {:error, :project_not_found | :not_owner}
  def remove_project(%{project_id: project_id, owner_id: owner_id}) do
    with project when not is_nil(project) <- Repo.get_by(Project, project_id: project_id),
         true <- project.owner_id == owner_id do
      Multi.new()
      |> Multi.delete_all(:delete_user_projects, from(up in UserProject, where: up.project_id == ^project_id))
      |> Multi.delete_all(
        :delete_tasks,
        from(t in Task,
             join: b in Board, on: b.board_id == t.board_id,
             join: p in Project, on: p.project_id == b.project_id,
             where: p.project_id == ^project_id)
      )
      |> Multi.delete_all(:delete_boards, from(b in Board, where: b.project_id == ^project_id))
      |> Multi.delete_all(:delete_task_types, from(ttp in TaskType, where: ttp.project_id == ^project_id))
      |> Multi.delete(:delete_project, project)
      |> Repo.transaction
    else
      nil -> {:error, :project_not_found}
      false -> {:error, :not_owner}
    end
  end

  @spec add_user_to_project(%{project_id: String.t(), user_id: String.t()}) ::
          {:ok, %UserProject{}} | list(String.t()) | {:error, :invalid}
  def add_user_to_project(%{project_id: project_id, user_id: user_id}) do
    with project when not is_nil(project) <- Repo.get_by(Project, project_id: project_id),
         user when not is_nil(user) <- Repo.get_by(User, user_id: user_id) do
      %UserProject{}
      |> UserProject.changeset(%{user_id: user_id, project_id: project_id})
      |> Repo.insert()
      |> case do
        {:ok, result} ->
          {:ok, result}

        {:error, result_errors} ->
          result_errors.errors |> Enum.map(fn {_, {error, _}} -> error end)
      end
    else
      error when error in [nil] -> {:error, :invalid}
    end
  end

  @spec add_user_to_project(%{project_id: Strint.t(), users: list(Strint.t())}) ::
          {:ok, list(any())} | {:error, :project_not_found}
  def add_user_to_project(%{project_id: project_id, users: user_list}) do
    list_of_added =
      case Repo.exists?(Project, project_id: project_id) do
        false ->
          {:error, :project_not_found}

        true ->
          for user <- user_list do
            if Repo.exists?(User, user_id: user) do
              %UserProject{}
              |> UserProject.changeset(%{project_id: project_id, user_id: user})
              |> Repo.insert()
            end
          end
      end

    {:ok, list_of_added}
  end

  @spec remove_user_from_project(%{project_id: String.t(), user_id: String.t()}) ::
          {:ok, %UserProject{}} | {:error, :user_not_found_in_project}
  def remove_user_from_project(%{project_id: project_id, user_id: user_id}) do
    case Repo.get_by(UserProject, project_id: project_id, user_id: user_id) do
      nil ->
        {:error, :user_not_found_in_project}

      user_project ->
        {:ok, deleted_result} = Repo.delete(user_project)
        {:ok, deleted_result}
    end
  end
end
