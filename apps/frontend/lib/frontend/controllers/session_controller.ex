defmodule Frontend.SessionController do
  use Frontend, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case Backend.get_user_by_username_and_password(username, password) do
      %Backend.User{} = user ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Successfully logged in")
        |> redirect(to: Routes.user_path(conn, :show, user))

      _ ->
        conn
        |> put_flash(:error, "That username and password combination cannot be found")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> configure_session(drop: true)
    |> redirect(to: Routes.frontpage_path(conn, :index))
  end
end
