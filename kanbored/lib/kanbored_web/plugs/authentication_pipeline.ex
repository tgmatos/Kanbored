defmodule Kanbored.AuthenticationPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :kanbored,
    module: Kanbored.UserManager,
    error_handler: KanboredWeb.ErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug Guardian.Plug.EnsureAuthenticated
end
