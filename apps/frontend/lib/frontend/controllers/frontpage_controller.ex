defmodule Frontend.FrontpageController do
  use Frontend, :controller

  def index(conn, _params) do
    submissions =
      Backend.get_submissions(30)
      |> Enum.map(fn submission ->
        # submission.user = Backend.get_user(submission.user_id)
          points = Backend.get_submission_upvote_count(submission.id)

        %{
          data: submission,
          user: Backend.get_user(submission.user_id),
          points: points,
          comments: Backend.get_comment_count(submission.id),
          ranking: Backend.get_ranking(points, submission.submitted_at),
          timestamp: Timestamp.relative_timestamp(submission.submitted_at)
        }
      end)

    render(conn, "index.html", submissions: submissions)
  end
end
