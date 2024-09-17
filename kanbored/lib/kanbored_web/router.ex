defmodule KanboredWeb.Router do
  use KanboredWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Kanbored.AuthenticationPipeline
  end

  scope "/api", KanboredWeb do
    live_dashboard "/dashboard", metrics: KanboredWeb.Telemetry
    pipe_through :api
    post "/user/register", UserController, :register
    post "/user/login", UserController, :login

    scope "/project" do
      pipe_through :auth
      post "/new", ProjectController, :new_project
      get "/:project", ProjectController, :get_project
      delete "/remove/:project", ProjectController, :remove_project

      scope "/user" do
        post "/user/add", ProjectController, :add_user_to_project
        delete "/user/remove/:project", ProjectController, :remove_user_from_project
      end
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
