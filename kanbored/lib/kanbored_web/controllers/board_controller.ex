defmodule KanboredWeb.BoardController do
  use KanboredWeb, :controller
  alias Kanbored.{Boards}
  
  def new_board(conn, %{"project" => project_id, "board" => board_name}) do
    with {:ok, board} <- Boards.new_board(%{project_id: project_id, board_name: board_name}) do
      render(conn, :new_board, %{board: board})
    end
  end

  # def remove_board(conn, ) do
  # end
end
