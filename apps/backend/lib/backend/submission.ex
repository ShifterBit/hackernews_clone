defmodule Backend.Submission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "submissions" do
    field(:title, :string)
    field(:text, :string)
    field(:url, :string)
    field(:votes, :integer, default: 0)

    has_many(:comments, Backend.Comment)
    belongs_to(:submitted_by, Backend.User, foreign_key: :user_id)

    timestamps()
  end

  def changeset(submission, params \\ %{}) do
    submission
    |> cast(params, [:title, :text, :url, :votes])
    |> validate_required([:title])
    |> cast_assoc(:submitted_by)
  end
end
