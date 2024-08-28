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
    post(conn, ~p"/api/user/register", %{
      email: "teste@gmail.com",
      username: "teste",
      password: "KPc5@GrnA@2W@WSdoTKD9i%Up5G!wT!uKMvM9!*KPc5@GrnA@2W@WSdoTKD9i%Up5G!wT!uKMvM9!*"
    })

    conn =
      post(conn, ~p"/api/user/login", %{
        email: "teste@gmail.com",
        password: "KPc5@GrnA@2W@WSdoTKD9i%Up5G!wT!uKMvM9!*KPc5@GrnA@2W@WSdoTKD9i%Up5G!wT!uKMvM9!*"
      })

    body = json_response(conn, 200)
    assert Map.has_key?(body, "bearer_token")
  end

  test "authenticated request", %{conn: conn} do
    post(conn, ~p"/api/user/register", %{
      email: "teste@gmail.com",
      username: "teste",
      password: "KPc5@GrnA@2W@WSdoTKD9i%Up5G!wT!uKMvM9!*KPc5@GrnA@2W@WSdoTKD9i%Up5G!wT!uKMvM9!*"
    })

    login_conn =
      post(conn, ~p"/api/user/login", %{
        email: "teste@gmail.com",
        password: "KPc5@GrnA@2W@WSdoTKD9i%Up5G!wT!uKMvM9!*KPc5@GrnA@2W@WSdoTKD9i%Up5G!wT!uKMvM9!*"
      })

    %{"bearer_token" => token} = json_response(login_conn, 200)

    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    conn = post(conn, ~p"/api/private/relay", %{relay: "testando"})
    %{"msg" => msg} = json_response(conn, 200)

    assert msg == %{"relay" => "testando"}
  end
end
