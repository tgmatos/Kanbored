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
end
