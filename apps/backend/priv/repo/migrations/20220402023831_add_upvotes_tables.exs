defmodule Backend.Repo.Migrations.AddUpvotesTables do
  use Ecto.Migration

  def change do

    create table "submission_upvotes" do
      add(:submission_id, references(:submissions))
      add(:user_id, references(:users))
    end

    create table "comment_upvotes" do
      add(:comment_id, references(:comments))
      add(:user_id, references(:users))
    end

    create unique_index("submission_upvotes", [:user_id, :submission_id])
    create unique_index("comment_upvotes", [:user_id, :comment_id])


  end
end
