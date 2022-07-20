defmodule Backend.Submission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "submissions" do
    field(:title, :string)
    field(:text, :string)
    field(:url, :string)

    has_many(:comments, Backend.Comment)
    belongs_to(:submitted_by, Backend.User, foreign_key: :user_id)

    timestamps()
  end

  def changeset(submission, params \\ %{}) do
    submission
    |> cast(params, [:title, :text, :url])
    |> validate_required([:title])
    |> cast_assoc(:submitted_by)
  end
end

defmodule Backend.Submission.Upvote do
  use Ecto.Schema

  schema "submission_upvotes" do
    field(:submission_id, :id)
    field(:user_id, :id)
  end

  @attrs [:submission_id, :user_id]

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @attrs)
    |> Ecto.Changeset.unique_constraint(@attrs)
  end
end
