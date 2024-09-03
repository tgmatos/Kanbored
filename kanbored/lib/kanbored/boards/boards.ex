defmodule Kanbored.Boards do
  alias Kanbored.Models.{Board, Project}
  alias Kanbored.Repo

  def new_board(attr \\ %{}) do
    insert_result =
      %Board{}
      |> Board.changeset(attr)
      |> Repo.insert()

    case insert_result do
      {:ok, board} ->
        {:ok, board}

      {:error, result_errors} ->
        result_errors.errors
        |> Enum.map(fn {_, {error, _}} -> error end)
    end
  end

  def remove_board(board_id) do
    case Repo.get_by(Board, board_id: board_id) do
      nil -> {:error, :not_found}
      board -> Repo.delete(board)
    end
  end
end
