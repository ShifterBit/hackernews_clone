defmodule Backend.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.{Comment, Submission, User}

  schema "comments" do
    field(:text, :string)
    field(:votes, :integer, default: 0)

    many_to_many(
      :replies,
      Comment,
      join_through: Backend.Comment.Closure,
      join_keys: [comment: :id, parent: :id]
    )

    belongs_to(:submission, Submission)
    belongs_to(:posted_by, User, foreign_key: :user_id)

    timestamps()
  end

  def changeset(comment, params \\ %{}) do
    comment
    |> cast(params, [:text, :votes])
    |> cast_assoc(:posted_by)
    |> validate_required([:text])
    |> validate_length(:text, min: 3)
  end
end

defmodule Backend.Comment.Closure do
  use Ecto.Schema

  schema "comment_closure" do
    field(:comment, :id)
    field(:parent, :id)
  end

  @attrs [:child_id, :parent_id]

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @attrs)
    |> Ecto.Changeset.unique_constraint(@attrs)
  end
end

defmodule Backend.Comment.Upvote do
  use Ecto.Schema

  schema "comment_upvotes" do
    field(:comment_id, :id)
    field(:user_id, :id)
  end

  @attrs [:comment_id, :user_id]

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, @attrs)
    |> Ecto.Changeset.unique_constraint(@attrs)
  end
end
  
