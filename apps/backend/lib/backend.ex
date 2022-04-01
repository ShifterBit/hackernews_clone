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

  def get_user_by(params) do
    Repo.get_by!(User, params)
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

  def get_comment(id) do
    Repo.get!(Comment, id)
  end

  def insert_reply(user_id, comment_id, params = %{}) do
    parent = get_comment(comment_id) |> Repo.preload(:replies)
    reply = create_comment(user_id, parent.submission_id, params)

    parent
    |> Changeset.change()
    |> Changeset.put_assoc(:replies, [reply | parent.replies])
    |> Repo.insert_or_update!() |> IO.inspect
  end

  def insert_comment(user_id, submission_id, params = %{}) do
    create_comment(user_id, submission_id, params)
    |> Repo.insert!()
  end

  def fake_data() do
    pass = "password123"
    insert_user(%{username: "user1", password: pass, password_confirmation: pass})
    insert_user(%{username: "user2", password: pass, password_confirmation: pass})
    insert_user(%{username: "user3", password: pass, password_confirmation: pass})
    insert_user(%{username: "user4", password: pass, password_confirmation: pass})
    user1 = get_user_by(username: "user1")

    insert_submission(user1.id, %{title: "Hacker news", url: "https://news.ycombinator.com"})
    insert_comment(1, 1, %{text: "first comment"})
    insert_comment(2, 1, %{text: "another comment"})

    insert_reply(1, 1, %{text: "reply to comment"})


  end
end
