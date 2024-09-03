defmodule KanboredWeb.Router do
  use KanboredWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Kanbored.AuthenticationPipeline
  end

  scope "/api", KanboredWeb do
    pipe_through :api
    post "/user/register", UserController, :register
    post "/user/login", UserController, :login

    scope "/project" do
      pipe_through :auth
      post "/new", ProjectController, :new_project
      post "/delete", ProjectController, :delete_project
      post "/add", ProjectController, :add_user_to_project
      post "/remove", ProjectController, :remove_user_from_project
    end
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:kanbored, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
