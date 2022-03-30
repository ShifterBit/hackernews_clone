defmodule Backend.Repo.Migrations.CreateSubmissionsUsersComments do
  use Ecto.Migration

  def change do
    create table("users") do
      add(:name, :string)
      add(:hashed_password, :string)

      timestamps()
    end

    create table("submissions") do
      add(:title, :string)
      add(:text, :string)
      add(:url, :string)
      add(:votes, :integer)

      add(:user_id, references(:users))

      timestamps()
    end

    create table("comments") do
      add(:text, :string)
      add(:votes, :integer)
      add(:parent_id, references(:comments))
      add(:user_id, references(:users))
      add(:submission_id, references(:submissions))

      timestamps()
    end
  end
end
