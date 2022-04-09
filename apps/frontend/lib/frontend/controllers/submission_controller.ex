defmodule Frontend.SubmissionController do
  use Frontend, :controller

  def index(conn, %{"id" => id}) do
    submission =
      String.to_integer(id)
      |> Backend.get_submission()
      |> Backend.Repo.preload(:comments)

    comments = submission.comments |> Backend.Repo.preload(:posted_by)

    render(conn, "index.html", %{submission: submission, comments: comments})
  end
end
