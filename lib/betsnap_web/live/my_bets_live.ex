defmodule BetsnapWeb.MyBetsLive do
  use BetsnapWeb, :live_view

  alias Betsnap.Accounts
  alias Betsnap.Accounts.User

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center text-white">
        My Bets
      </.header>
    </div>
    """
  end
end
