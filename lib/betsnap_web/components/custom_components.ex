defmodule BetsnapWeb.CustomComponents do
  use Phoenix.Component

  @spec topbar(any()) :: Phoenix.LiveView.Rendered.t()
  def topbar(assigns) do
    ~H"""
    <div class="topbar fixed w-full bg-brand h-auto px-5 py-5 flex justify-between align-center shadow-md z-50">
        <div class="w-24">
          <img
            src={"/images/logo-text.png"}
            alt="Betsnap"
            class="w-full h-20px"
          />
        </div>
        <div class="w-1/4">
          <ul class="w-full flex justify-center">
            <li>
              <.link
                href={"/"}
                class="text-white p-2 rounded-md mx-2 hover:bg-white hover:text-brand font-semibold transition duration-200"
              >
                Home
              </.link>
            </li>
            <%= if @current_user do %>
              <li>
                <.link
                  href={"/my-bets"}
                  class="text-white p-2 rounded-md mx-2 hover:bg-white hover:text-brand font-semibold transition duration-200"
                >
                  My Bets
                </.link>
              </li>
            <% end %>
          </ul>
        </div>
        <div class="flex">
          <ul class="w-full flex">
            <%= if @current_user do %>
              <li class="text-[0.8125rem] leading-6 text-white">
                <%= @current_user.email %>
              </li>
              <li>
                <.link
                  href={"/users/settings"}
                  class="text-white p-2 rounded-md mx-2 hover:bg-white hover:text-brand font-semibold transition duration-200"
                >
                  Settings
                </.link>
              </li>
              <li>
                <.link
                  href={"/users/log_out"}
                  method="delete"
                  class="text-white p-2 rounded-md mx-2 hover:bg-white hover:text-brand font-semibold transition duration-200"
                >
                  Log out
                </.link>
              </li>
            <% else %>
              <li>
                <.link
                  href={"/users/register"}
                  class="text-white p-2 rounded-md mx-2 hover:bg-white hover:text-brand font-semibold transition duration-200"
                >
                  Register
                </.link>
              </li>
              <li>
                <.link
                  href={"/users/log_in"}
                  class="text-white p-2 rounded-md mx-2 hover:bg-white hover:text-brand font-semibold transition duration-200"
                >
                  Log in
                </.link>
              </li>
            <% end %>
          </ul>
        </div>
    </div>
    """
  end

  def sidebar(assigns) do
    ~H"""
      <div class="h-screen p-2 pb-[5rem] bg-brand flex flex-col overflow-auto custom-slider">
        <p class="font-bold text-white mb-2">Countries</p>
        <ul class="flex flex-col">
          <%= for country <- @countries do %>
            <div class="flex ml-2">
              <%= if country["name"] != "World" do %>
                <img
                  src={country["flag"]}
                  alt={country["country"]}
                  class="w-5 h-5"
                />
              <% end %>
              <li
              class={if @selected_country === country["code"], do: "text-white ml-2 font-bold",
              else: "text-white ml-1 mb-1 hover:ml-2 cursor-pointer transition-all"}
              ><%= country["name"] %></li>
            </div>
          <% end %>
        </ul>
      </div>
    """
  end

end
