defmodule Frontend.SubmissionController do
  use Frontend, :controller

  def index(conn, %{"id" => id}) do
    submission =
      String.to_integer(id)
      |> Backend.get_submission()
      |> Backend.Repo.preload(:comments)

    comments =
      case length(submission.comments) do
        0 ->
          []

        _ ->
          submission.comments
          |> Backend.Repo.preload([:posted_by, replies: [:posted_by, :replies]])
      end

    render(conn, "index.html", %{
      submission: submission,
      comments: comments,
      user: Backend.get_user(submission.user_id),
      points: Backend.get_comment_upvote_count(submission.id),
      comment_count: Backend.get_comment_count(submission.id),
      timestamp: Timestamp.relative_timestamp(submission.inserted_at)
    })
  end

  def new(conn, _params) do
    user_id = get_session(conn, :user_id)
    submission = Backend.create_submission(user_id)

    render(conn, "new.html", submission: submission, user_id: user_id)
  end

  def create(conn, %{"submission" => params}) do
    id = get_session(conn, :user_id)

    case Backend.insert_submission(id, params) do
      {:ok, submission} ->
        redirect(conn, to: Routes.submission_path(conn, :index, submission.id)) |> IO.inspect()

      {:error, submission} ->
        render(conn, "new.html", submission: submission)
    end
  end
end
