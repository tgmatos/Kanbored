defmodule KanboredWeb.BoardJson do
  def new_board(%{board: board}) do
    %{result: %{board: board}}
  end
end
