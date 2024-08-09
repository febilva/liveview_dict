defmodule BichuWeb.HomeLive do
  use BichuWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :form, to_form(%{}))}
  end

  def handle_event("search", %{"search" => search}, socket) do
    meanings = BichuWeb.Dictionary.search(search)
    {:noreply, assign(socket, :form, to_form(%{search: search, meanings: meanings}))}
  end
end
