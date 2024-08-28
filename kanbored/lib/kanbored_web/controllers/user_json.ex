defmodule KanboredWeb.UserJSON do
  def register(%{msg: user_params}) do
    %{
      username: Map.get(user_params, "username"),
      email: Map.get(user_params, "email")
    }
  end

  def login(%{bearer_token: token}) do
    %{bearer_token: token}
  end

  def relay(%{msg: params}) do
    %{msg: params}
  end

  def handle_error(%{reason: reason}) do
    %{error: reason}
  end
end
