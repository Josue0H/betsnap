defmodule BetsnapWeb.UserSettingsLive do
  use BetsnapWeb, :live_view

  alias Betsnap.Accounts

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Account Settings
      <:subtitle>Manage your account email address and password settings</:subtitle>
    </.header>

    <div class="mx-auto max-w-sm">
      <div>
        <.simple_form
          for={@username_form}
          id="username_form"
          phx-submit="update_username"
          phx-change="validate_username"
        >
          <.input
            field={@username_form[:email]}
            type="hidden"
            id="hidden_user_email"
          />
          <.input field={@username_form[:username]} type="text" label="Username" required name="current_username"/>
          <:actions>
            <.button phx-disable-with="Saving...">Save Changes</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@email_form}
          id="email_form"
          phx-submit="update_email"
          phx-change="validate_email"
        >
          <.input field={@email_form[:email]} type="email" label="Email" required />
          <.input
            field={@email_form[:current_password]}
            name="current_password"
            id="current_password_for_email"
            type="password"
            label="Current password"
            value={@email_form_current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Email</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          action={~p"/users/log_in?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <.input
            field={@password_form[:email]}
            type="hidden"
            id="hidden_user_email"
            value={@current_email}
          />
          <.input field={@password_form[:password]} type="password" label="New password" required />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Confirm new password"
          />
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label="Current password"
            id="current_password_for_password"
            value={@current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Password</.button>
          </:actions>
        </.simple_form>
      </div>
      <div class="w-full flex justify-around my-5">
        <.button phx-disable-with="Changing..." phx-click="add_balance" phx-value-balance="100">
          + $100
        </.button>
        <.button phx-disable-with="Changing..." phx-click="add_balance" phx-value-balance="200">
          + $200
        </.button>
        <.button phx-disable-with="Changing..." phx-click="add_balance" phx-value-balance="500">
          + $500
        </.button>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    username_changeset = Accounts.change_username(user)
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:current_username, user.username)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:username_form, to_form(username_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("add_balance", %{"balance" => balance}, socket) do
    user =
      socket.assigns.current_user
      |> Accounts.add_balance(balance)

    {:noreply,
     socket
     |> put_flash(:info, "Balance updated successfully.")
     |> assign(current_user: user)
     |> redirect(to: "/users/settings")}
  end

  def handle_event("validate_username", params, socket) do
    %{"current_username" => username, "user" => user_params} = params

    username_form =
      socket.assigns.current_user
      |> Accounts.change_username(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    IO.inspect(username_form, label: "username_form")

    {:noreply, assign(socket, username_form: username_form, current_username: username)}
  end


  def handle_event("update_username", params, socket) do
    %{"current_username" => username, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_username(user, %{ username: username }) do
      {:ok, user} ->
        username_form =
          user
          |> Accounts.change_username(user_params)
          |> to_form()

        {:noreply, socket |> assign(username_form: username_form) |> put_flash(:info, "Username updated successfully." ) |> redirect(to: "/users/settings")}

      {:error, changeset} ->
        {:noreply, socket |> assign(username_form: to_form(changeset)) |> put_flash(:error, "Username could not be updated.")}
    end
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
