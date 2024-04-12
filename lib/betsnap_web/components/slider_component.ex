defmodule BetsnapWeb.ImageSlider do
  @moduledoc """
  Image slider component
  """

  use BetsnapWeb, :live_component

  def mount(socket) do
    if connected?(socket), do: :timer.send_interval(5000, self(), :next_slide)

    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, value: assigns.value, elements: assigns.elements)}
  end

  def render(assigns) do
    ~H"""
    <div class="w-full h-1/2 relative pb-2 px-2">
      <%= if @value > 0 do %>
        <div phx-target={@myself} phx-click="prev">
          <.icon
            name="hero-chevron-left"
            class="absolute left-2 top-1/2 h-9 w-9 z-10 text-white cursor-pointer hover:bg-brand transition-all"
          />
        </div>
      <% end %>

      <%= for element <- @elements do %>
        <%= if @value == element.id do %>
          <.element title={element.title} subtitle={element.subtitle} image={element.image} />
        <% end %>
      <% end %>

      <%= if @value < length(@elements) - 1 do %>
        <div phx-target={@myself} phx-click="next">
          <.icon
            name="hero-chevron-right"
            class="absolute right-2 top-1/2 right-0 h-9 w-9 z-10 text-white cursor-pointer hover:bg-brand transition-all"
          />
        </div>
      <% end %>
    </div>
    """
  end

  def element(assigns) do
    ~H"""
    <div class="w-full h-full bg-white flex items-center justify-center relative">
      <img src={@image} alt="slide-1" class="w-full h-full object-cover" />
      <div class="absolute flex flex-col items-center">
        <h1 class="text-white font-bold text-5xl mb-3"><%= @title %></h1>

        <h3 class="text-white"><%= @subtitle %></h3>
      </div>
    </div>
    """
  end

  def handle_event("next", _, socket) do
    {:noreply, assign(socket, :value, socket.assigns.value + 1)}
  end

  def handle_event("prev", _, socket) do
    {:noreply, assign(socket, :value, socket.assigns.value - 1)}
  end
end
