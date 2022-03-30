defmodule Backend do
  alias Backend.{Submission, Comment, Repo, User}
  alias Ecto.Changeset

  def insert_user(params = %{}) do
    %User{}
    |> User.changeset_with_password(params)
    |> Repo.insert!()
  end

  def get_user(user_id) do
    Repo.get!(User, user_id)
  end

  def create_submission(user_id, params = %{}) do
    user = get_user(user_id)

    %Submission{}
    |> Repo.preload(:submitted_by)
    |> Submission.changeset(params)
    |> Changeset.put_assoc(:submitted_by, user)
  end

  def get_submission(submission_id) do
    Repo.get!(Submission, submission_id)
  end

  def insert_submission(user_id, params = %{}) do
    create_submission(user_id, params)
    |> Repo.insert!()
  end

  def create_comment(user_id, submission_id, params = %{}) do
    user = get_user(user_id)
    submission = get_submission(submission_id)

    %Comment{}
    |> Repo.preload([:posted_by, :submission])
    |> Comment.changeset(params)
    |> Changeset.put_assoc(:posted_by, user)
    |> Changeset.put_assoc(:submission, submission)
  end

  def insert_comment(user_id, submission_id, params = %{}) do
    create_comment(user_id, submission_id, params)
    |> Repo.insert!()
  end
end
