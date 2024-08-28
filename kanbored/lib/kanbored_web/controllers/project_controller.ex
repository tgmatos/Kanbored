defmodule KanboredWeb.ProjectController do
  use KanboredWeb, :controller
  alias Kanbored.Projects

  action_fallback KanboredWeb.FallbackController

  def new_project(conn, params) do
    %{"name" => name, "description" => description, "owner_id" => owner_id} = params

    with {:ok, result} <-
           Projects.new_project(%{
             project_name: name,
             description: description,
             owner_id: owner_id
           }) do
      render(conn, :new_project, msg: result)
    end
  end

  def add_user_to_project(conn, %{"project" => project_id, "user" => user_id}) do
    with {:ok, result} <-
           Projects.add_user_to_project(%{project_id: project_id, user_id: user_id}) do
      render(conn, :add_user_to_project, msg: result)
    end
  end

  def add_user_to_project(conn, %{"project" => project_id, "users" => user_list}) do
    with {:ok, result} <-
           Projects.add_user_to_project(%{project_id: project_id, users: user_list}) do
      render(conn, :add_user_to_project, %{project_id: project_id, result: result})
    end
  end

  def remove_user_from_project(conn, %{"project" => project_id, "user" => user_id}) do
    case Projects.remove_user_from_project(%{project_id: project_id, user_id: user_id}) do
      {:ok, result} -> render(conn, :remove_user_from_project, result: result)
    end
  end
end
