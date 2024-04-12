defmodule BetsnapWeb.UserSessionController do
  use BetsnapWeb, :controller

  alias Betsnap.Accounts
  alias BetsnapWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    new_user_params = %{
      "identifier" => params["user"]["email"],
      "email" => params["user"]["email"],
      "username" => params["user"]["username"],
      "password" => params["user"]["password"]
    }

    params = Map.put(params, "user", new_user_params)

    create(conn, params, "Account created successfully!")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "Password updated successfully!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"identifier" => identifier, "password" => password} = user_params
    # %{"email" => email, "username" => username, "password" => password} = user_params

    if user = Accounts.get_user_by_identifier_password(identifier, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:identifier, String.slice(identifier, 0, 160))
      |> redirect(to: ~p"/users/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
