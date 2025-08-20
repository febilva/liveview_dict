defmodule OlamWeb.HomeLive do
  use OlamWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket, :meanings, [])
      |> assign(:show_attribution, false)

    {:ok, assign(socket, :form, to_form(%{})), layout: false}
  end

  def handle_event("get_suggestions", %{"search" => search}, socket) do
    meanings = Olam.Dict.search(search)

    socket =
      socket
      |> assign(:meanings, meanings)
      |> assign(:form, to_form(%{search: search}))

    {:noreply, socket}
  end

  def handle_event("clear_search", _params, socket) do
    socket = assign(socket, :meanings, [])
    {:noreply, socket}
  end

  def handle_event("toggle_attribution", _params, socket) do
    {:noreply, assign(socket, :show_attribution, !socket.assigns.show_attribution)}
  end

  def open_modal(js \\ %JS{}) do
    js
    |> JS.show(
      to: "#searchbox_container",
      transition:
        {"transition ease-out duration-200", "opacity-0 scale-95", "opacity-100 scale-100"}
    )
    |> JS.show(
      to: "#searchbar-dialog",
      transition: {"transition ease-in duration-100", "opacity-0", "opacity-100"}
    )
    |> JS.focus(to: "#search-input")
  end

  def hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(
      to: "#searchbar-searchbox_container",
      transition:
        {"transition ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"}
    )
    |> JS.hide(
      to: "#searchbar-dialog",
      transition: {"transition ease-in duration-100", "opacity-100", "opacity-0"}
    )
  end

  # def select_meaning(english_word_or_letter) do
  #   IO.inspect(english_word_or_letter)
  #   {:ok, assign(socket, :show_meanings_model, true)}
  # end
end
