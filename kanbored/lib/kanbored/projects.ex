defmodule Kanbored.Projects do
  alias Kanbored.{Repo, Models.Project, Models.UserProject, Models.User}

  def new_project(attr \\ %{}) do
    result =
      %Project{}
      |> Project.create_project_changeset(attr)
      |> Repo.insert()

    case result do
      {:ok, project} ->
        {:ok, project}

      {:error, result_error} ->
        result_error.errors
        |> Enum.map(fn {_, {error, _}} -> error end)
    end
  end

  def add_user_to_project(%{project_id: project_id, user_id: user_id}) do
    with project when not is_nil(project) <- Repo.get_by(Project, project_id: project_id),
         user when not is_nil(user) <- Repo.get_by(User, user_id: user_id) do
      insert_result =
        %UserProject{}
        |> UserProject.changeset(%{user_id: user_id, project_id: project_id})
        |> Repo.insert()

      case insert_result do
        {:ok, result} ->
          {:ok, result}

        {:error, result_errors} ->
          result_errors.errors
          |> Enum.map(fn {_, {error, _}} -> error end)
      end
    else
      error when error in [nil] -> [:error, :invalid]
    end
  end

  def add_user_to_project(%{project_id: project_id, users: user_list}) do
    list_of_added =
      case Repo.exists?(Project, project_id: project_id) do
        false ->
          {:error, :project_not_found}

        true ->
          for user <- user_list do
            if(Repo.exists?(User, user_id: user)) do
              %UserProject{}
              |> UserProject.changeset(%{project_id: project_id, user_id: user})
              |> Repo.insert()
            end
          end
      end

    {:ok, list_of_added}
  end

  def remove_user_from_project(%{project_id: project_id, user_id: user_id}) do
    case Repo.get_by(UserProject, project_id: project_id, user_id: user_id) do
      nil -> {:error, :user_not_found_in_project}
      user_project ->
        {:ok, deleted_result} = Repo.delete(user_project)
        {:ok, deleted_result}
    end
  end
end
