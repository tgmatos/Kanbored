defmodule KanboredWeb.ProjectController do
  use KanboredWeb, :controller
  alias Kanbored.Projects

  action_fallback KanboredWeb.FallbackController

  def new_project(conn, %{"name" => name, "description" => description, "owner_id" => owner_id}) do
    with {:ok, result} <-
           Projects.new_project(%{
             project_name: name,
             description: description,
             owner_id: owner_id
           }) do
      render(conn, :new_project, msg: result)
    end
  end

  def get_project(conn, %{"project" => project_id}) do
    %{private: %{:guardian_default_claims => %{"sub" => user_id}}} = conn
    case Projects.get_project(%{project_id: project_id, user_id: user_id}) do
      {:ok, project} -> render(conn, :get_project, %{project: project})
      {:error, :user_not_found_in_project} -> render(conn, :user_not_found_in_project)
      {:error, :project_not_found} -> render(conn, :project_not_found)
    end
  end

  def remove_project(conn, %{"project" => project_id}) do
    %{private: %{:guardian_default_claims => %{"sub" => owner_id}}} = conn

    case Projects.delete_project(%{project_id: project_id, owner_id: owner_id}) do
      {:ok, _} -> render(conn)
      {:error, :project_not_found} -> render(conn, :project_not_found)
      {:error, :not_owner} -> render(conn, :not_owner)
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

  def remove_user_from_project(conn, %{"project" => project_id}) do
    %{private: %{:guardian_default_claims => %{"sub" => user_id}}} = conn
    
    with {:ok, result} <-
           Projects.remove_user_from_project(%{project_id: project_id, user_id: user_id}) do
      render(conn, :remove_user_from_project, result: result)
    end
  end
end
