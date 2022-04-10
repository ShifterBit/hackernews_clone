defmodule Frontend.UserView do
  use Frontend, :view

  def get_timestamp(date) do
    Timestamp.relative_timestamp(date)
  end
end
