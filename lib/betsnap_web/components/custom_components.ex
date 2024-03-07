defmodule BetsnapWeb.CustomComponents do
  use Phoenix.Component

  import Number.Currency

  def topbar(assigns) do
    ~H"""
    <div class="topbar fixed w-full bg-brand h-auto px-5 py-5 flex justify-between items-center shadow-md z-[500]">
      <div class="w-24">
        <.link href="/" class="text-white font-bold text-2xl">
          <img
            src="/images/logo-text.png"
            alt="Betsnap"
            class="w-full h-20px hover:scale-[1.03] transition-all"
          />
        </.link>
      </div>
      
      <div class="flex">
        <ul class="w-full flex">
          <%= if @current_user do %>
            <li class="text-[0.8125rem] leading-6 text-white mx-5">
              <span>
                <%= @current_user.username %> | <%= number_to_currency(@current_user.balance) %>
              </span>
            </li>
            
            <li>
              <.link
                href="/my-bets"
                class="text-white p-2 hover:bg-white hover:text-brand font-semibold transition duration-200"
              >
                My Bets
              </.link>
            </li>
            
            <li>
              <.link
                href="/users/settings"
                class="text-white p-2 hover:bg-white hover:text-brand font-semibold transition duration-200"
              >
                Settings
              </.link>
            </li>
            
            <li>
              <.link
                href="/users/log_out"
                method="delete"
                class="text-white p-2 hover:bg-white hover:text-brand font-semibold transition duration-200"
              >
                Log out
              </.link>
            </li>
          <% else %>
            <li>
              <.link
                href="/users/register"
                class="text-white p-2 hover:bg-white hover:text-brand font-semibold transition duration-200"
              >
                Register
              </.link>
            </li>
            
            <li>
              <.link
                href="/users/log_in"
                class="text-white p-2 hover:bg-white hover:text-brand font-semibold transition duration-200"
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
    <p class="font-bold text-white mb-2">Countries</p>

    <ul class="flex flex-col">
      <%= for country <- @countries do %>
        <div class="flex ml-2">
          <%= if country["name"] != "World" do %>
            <img src={country["flag"]} alt={country["country"]} class="w-5 h-5" />
          <% end %>
          
          <.link
            href={"/country?code=#{country["code"]}"}
            class="text-white ml-1 mb-1 hover:ml-2 cursor-pointer transition-all"
          >
            <%= country["name"] %>
          </.link>
        </div>
      <% end %>
    </ul>
    """
  end

  def decimal_to_currency(decimal) do
    decimal
    |> Decimal.to_string()
    |> String.replace(~r/(\d)(?=(\d{3})+(?!\d))/, "\\1,")
  end
end
