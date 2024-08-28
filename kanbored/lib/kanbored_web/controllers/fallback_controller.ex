defmodule KanboredWeb.FallbackController do
  use KanboredWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(401)
    |> put_view(json: KanboredWeb.ErrorJSON)
    |> render(:"401")
  end

  def call(conn, errors) when is_list(errors) == true do
    conn
    |> put_status(400)
    |> put_view(json: KanboredWeb.ErrorJSON)
    |> render(:"400")
  end

  def call(conn, {:error, :user_not_found_in_project}) do
    conn
    |> put_static_url(400)
    |> put_view(json: KanboredWeb.ErrorJSON)
    |> render(:"400")
  end
end
