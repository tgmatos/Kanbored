defmodule KanboredWeb.UserControllerTest do
  use KanboredWeb.ConnCase, async: true

  test "register", %{conn: conn} do
    conn =
      post(conn, ~p"/api/user/register", %{
        email: "teste@gmail.com",
        username: "teste",
        password: "KPc5@GrnA@2W@WSdoTKD9i%Up5G!wT!uKMvM9!*KPc5@GrnA@2W@WSdoTKD9i%Up5G!wT!uKMvM9!*"
      })

    assert json_response(conn, 200)
  end

  test "login", %{conn: conn} do
    conn =
      post(conn, ~p"/api/user/login", %{
        email: "teste1@teste.com",
        password: "rMv2u$MYU8Ww!C73xcn4E5@ea"
      })

    body = json_response(conn, 200)
    assert Map.has_key?(body, "bearer_token")
  end

  test "authenticated request", %{conn: conn} do
    login_conn =
      post(conn, ~p"/api/user/login", %{
        email: "teste1@teste.com",
        password: "rMv2u$MYU8Ww!C73xcn4E5@ea"
      })

    %{"bearer_token" => token} = json_response(login_conn, 200)

    conn = put_req_header(conn, "authorization", "Bearer #{token}")

    conn =
      post(conn, ~p"/api/project/new", %{
        name: "projeto_teste",
        description: "projeto de teste",
        owner_id: "bf126290-5065-47fe-8bac-9c5e40536e48"
      })

    %{"description" => "projeto de teste", "name" => "projeto_teste"} = json_response(conn, 200)
  end
end
