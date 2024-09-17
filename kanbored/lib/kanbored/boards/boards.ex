defmodule Kanbored.Boards do
  alias Kanbored.{Board, Task, UserProject}
  alias Kanbored.Repo
  alias Ecto.Multi
  import Ecto.Query

  def new_board(attr \\ %{}) do
    %Board{}
    |> Board.changeset(attr)
    |> Repo.insert()
    |> case do
      {:ok, board} -> {:ok, board}
      {:error, result_errors} -> result_errors.errors |> Enum.map(fn {_, {error, _}} -> error end)
    end
  end
  
  def remove_board(%{project_id: project_id, board_id: board_id, user_id: user_id}) do
    Multi.new()
    |> Multi.run(:check_user_in_project, fn repo, _changes ->
      check_user_in_project(repo, %{project_id: project_id, user_id: user_id})
    end)
    |> Multi.run(:board, fn repo, _changes -> get_board(repo, board_id) end)
    |> Multi.delete_all(:delete_tasks, &delete_tasks/1)
    |> Multi.delete(:delete_board, &delete_board/1)
    |> Repo.transaction
  end

  defp check_user_in_project(repo, %{project_id: project_id, user_id: user_id}) do
    case repo.exists?(UserProject, project_id: project_id, user_id: user_id) do
      false -> {:error, :user_not_found_on_project}
      true -> {:ok, true}
    end
  end

  defp get_board(repo, board_id) do
    case repo.get(Board, board_id) do
      nil -> {:error, :board_not_found}
      board -> {:ok, board}
    end
  end  

  defp delete_tasks(%{board: board}), do: from(t in Task, where: t.board_id == ^board.board_id)

  defp delete_board(%{board: board}), do: board
end
