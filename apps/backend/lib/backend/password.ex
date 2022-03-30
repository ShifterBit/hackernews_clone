defmodule Backend.Password do
  alias Pbkdf2

  def hash(password) do
    Pbkdf2.hash_pwd_salt(password)
  end

  def verify_password(password, hash) do
    Pbkdf2.verify_pass(password, hash)
  end
end
