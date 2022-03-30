defmodule Backend.User do
  use Ecto.Schema
  alias Backend.Password
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:hashed_password, :string)
    field(:password, :string, virtual: true)

    has_many(:submissions, Backend.Submission, foreign_key: :user_id)
    has_many(:comments, Backend.Comment, foreign_key: :user_id)

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name])
    |> validate_length(:name, min: 2)
  end

  def changeset_with_password(user, params \\ %{}) do
    user
    |> cast(params, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, required: true)
    |> hash_password()
    |> changeset(params)
  end

  defp hash_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:hashed_password, Password.hash(password))
  end

  defp hash_password(changeset), do: changeset
end
