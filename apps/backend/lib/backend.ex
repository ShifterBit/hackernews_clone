defmodule Backend do
  alias Backend.{Submission, Comment, Repo, User, Password}
  alias Ecto.Changeset
  import Ecto.Query

  def create_user(), do: User.changeset_with_password(%User{})

  def insert_user(params) do
    %User{}
    |> User.changeset_with_password(params)
    |> Repo.insert()
  end

  def get_user(user_id) do
    Repo.get(User, user_id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def get_user_by_username_and_password(username, password) do
    with user when not is_nil(user) <- get_user_by(%{username: username}),
         true <- Password.verify_password(password, user.hashed_password) do
      user
    else
      _ -> false
    end
  end

  def create_submission(user_id, params \\ %{}) do
    user = get_user(user_id)

    %Submission{}
    |> Repo.preload(:submitted_by)
    |> Submission.changeset(params)
    |> Changeset.put_assoc(:submitted_by, user)
  end

  def get_submissions(limit \\ nil) when is_number(limit) or is_nil(limit) do
    query =
      from(s in Backend.Submission,
        select: %{
          id: s.id,
          user_id: s.user_id,
          url: s.url,
          text: s.text,
          title: s.title,
          submitted_at: s.inserted_at
        }
      )

    case limit do
      nil ->
        Repo.all(query)

      limit ->
        query = from(s in query, limit: ^limit)
        Repo.all(query)
    end
  end

  def get_submission(submission_id) do
    Repo.get!(Submission, submission_id)
  end

  def upvote_submission(user_id, submission_id) do
    params = %{submission_id: submission_id, user_id: user_id}

    %Submission.Upvote{}
    |> Submission.Upvote.changeset(params)
    |> Repo.insert!()
  end

  def remove_upvote_from_submission(user_id, submission_id) do
    query =
      from(u in Submission.Upvote,
        where: u.user_id == ^user_id and u.submission_id == ^submission_id,
        select: u.id
      )

    id = Repo.one(query)
    Repo.delete(id)
  end

  def get_comment_count(submission_id) do
    query =
      from(s in Backend.Comment,
        where: s.submission_id == ^submission_id,
        select: count(s.id)
      )

    Repo.one(query)
  end

  def get_submission_upvote_count(submission_id) do
    query =
      from(u in Submission.Upvote,
        where: u.submission_id == ^submission_id,
        select: count(u.id)
      )

    Repo.one(query)
  end

  def insert_submission(user_id, params) do
    create_submission(user_id, params)
    |> Repo.insert()
  end

  def create_comment(user_id, submission_id, params) do
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

  def insert_reply(user_id, comment_id, params) do
    parent = get_comment(comment_id) |> Repo.preload(:replies)
    reply = create_comment(user_id, parent.submission_id, params)

    parent
    |> Changeset.change()
    |> Changeset.put_assoc(:replies, [reply | parent.replies])
    |> Repo.insert_or_update!()
    |> IO.inspect()
  end

  def insert_comment(user_id, submission_id, params) do
    create_comment(user_id, submission_id, params)
    |> Repo.insert!()
  end

  def upvote_comment(user_id, comment_id) do
    params = %{comment_id: comment_id, user_id: user_id}

    %Comment.Upvote{}
    |> Comment.Upvote.changeset(params)
    |> Repo.insert!()
  end

  def remove_upvote_from_comment(user_id, comment_id) do
    query =
      from(u in Comment.Upvote,
        where: u.user_id == ^user_id and u.comment_id == ^comment_id,
        select: u.id
      )

    id = Repo.one(query)
    Repo.delete(id)
  end

  def get_ranking(upvote_count, submission_time) do
    age = NaiveDateTime.diff(NaiveDateTime.utc_now(), submission_time, :second) / (60 * 60)
    (upvote_count - 1) / (age + 2) ** 1.8
    # Score = (P-1) / (T+2)^G
    # P = points
    # T = Time since submission
    # Gravity, default 1.8
  end

  def get_comment_upvote_count(comment_id) do
    query =
      from(u in Comment.Upvote,
        where: u.comment_id == ^comment_id,
        select: count(u.id)
      )

    Repo.one(query)
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
