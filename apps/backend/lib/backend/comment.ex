defmodule Backend.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.{Comment, Submission, User}

  schema "comments" do
    field(:text, :string)
    field(:votes, :integer, default: 0)
    field(:parent_id, :id)
    belongs_to(:parent_comment, Comment, foreign_key: :parent_id, references: :id, define_field: false)
    has_many(:subcomments, Comment, foreign_key: :parent_id, references: :id)

    belongs_to(:submission, Submission)
    belongs_to(:posted_by, User, foreign_key: :user_id)

    timestamps()
  end

  def changeset(comment, params \\ %{}) do
    comment
    |> cast(params, [:text, :votes, :parent_id])
    |> cast_assoc(:posted_by)
    |> validate_required([:text])
    |> validate_length(:text, min: 3)
  end
end
