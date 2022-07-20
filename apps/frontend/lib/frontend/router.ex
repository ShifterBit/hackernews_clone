defmodule Frontend.Router do
  use Frontend, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Frontend.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Frontend.Authenticator
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Frontend do
    pipe_through :browser

    get "/", FrontpageController, :index
    get "/item/:id", SubmissionController, :index
    post "/item/new", SubmissionController, :create
    get "/submit", SubmissionController, :new
    get "/register", UserController, :new
    post "/user/new", UserController, :create
    get "/user/:id", UserController, :show
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Frontend do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Frontend.Telemetry
    end
  end
end
