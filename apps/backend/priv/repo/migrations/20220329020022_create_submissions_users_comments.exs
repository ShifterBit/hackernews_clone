defmodule Backend.Repo.Migrations.CreateSubmissionsUsersComments do
  use Ecto.Migration

  def change do
    create table("users") do
      add(:username, :string, null: false)
      add(:hashed_password, :string, null: false)

      timestamps()
    end

    create(index("users", [:username], unique: true))

    create table("submissions") do
      add(:title, :string, null: false)
      add(:text, :string)
      add(:url, :string)
      add(:votes, :integer)

      add(:user_id, references(:users), null: false)

      timestamps()
    end

    create table("comments") do
      add(:text, :string, null: false)
      add(:votes, :integer, default: 0)
      add(:user_id, references(:users), null: false)
      add(:submission_id, references(:submissions), null: false)

      timestamps()
    end

    create table("comment_closure") do
      add(:parent, references(:comments))
      add(:comment, references(:comments))

    end

    create(index(:comment_closure, [:parent]))
    create(index(:comment_closure, [:comment]))

    create(unique_index(:comment_closure, [:comment, :parent]))
  end
end
