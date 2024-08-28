defmodule KanboredWeb.UserController do
  use KanboredWeb, :controller
  alias Kanbored.Users
  require Logger

  action_fallback KanboredWeb.FallbackController

  def register(conn, params) do
    %{"email" => email, "username" => username, "password" => password} = params

    with {:ok, result} <-
           Users.register(%{email: email, username: username, plain_password: password}) do
      render(conn, :register, msg: result)
    end
  end

  def login(conn, params) do
    %{"email" => email, "password" => password} = params

    with {:ok, token} <- Users.login(%{email: email, plain_password: password}) do
      render(conn, :login, bearer_token: token)
    end
  end
end
