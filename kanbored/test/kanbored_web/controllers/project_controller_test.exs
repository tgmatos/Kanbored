defmodule KanboredWeb.ProjectControllerTest do
  use KanboredWeb.ConnCase, async: true

  test "new_project", %{conn: conn} do
    login_conn =
      post(conn, ~p"/api/user/login", %{
        email: "teste1@teste.com",
        password: "rMv2u$MYU8Ww!C73xcn4E5@ea"
      })

    %{"bearer_token" => token} = json_response(login_conn, 200)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")

    conn =
      post(
        conn,
        ~p"/api/project/new",
        %{
          name: "Test Project",
          description: "Test Project",
          owner_id: "bf126290-5065-47fe-8bac-9c5e40536e48"
        }
      )

    result = json_response(conn, 200)
    assert result == %{"name" => "Test Project", "description" => "Test Project"}
  end
  
  test "add_user_to_project", %{conn: conn} do
    login_conn =
      post(conn, ~p"/api/user/login", %{
        email: "teste1@teste.com",
        password: "rMv2u$MYU8Ww!C73xcn4E5@ea"
      })

    %{"bearer_token" => token} = json_response(login_conn, 200)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")

    conn =
      post(conn, ~p"/api/user/", %{})
      )
  end
end
