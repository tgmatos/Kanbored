defmodule KanboredWeb.ProjectControllerTest do
  use KanboredWeb.ConnCase, async: true

  test "new_project", %{conn: conn} do
    login_conn =
      post(conn, ~p"/api/user/login", %{
        email: "tiago@gmail.com",
        password: "rMv2u$MYU8Ww!C73xcn4E5@ea"
      })

    %{"bearer_token" => token} = json_response(login_conn, 200)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")

    conn =
      post(
        conn,
        ~p"/api/private/project/new",
        %{
          name: "Test Project",
          description: "Test Project",
          owner_id: "be86d3ef-3d97-4c8c-af1e-fee7f589c5df"
        }
      )

    result = json_response(conn, 200)
    assert result == %{"name" => "Test Project", "description" => "Test Project"}
  end
end
