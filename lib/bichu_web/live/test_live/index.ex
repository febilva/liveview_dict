defmodule BichuWeb.TestLive do
  use BichuWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket, :meanings, [])
      |> assign(:show_meanings_modal, false)

    {:ok, assign(socket, :form, to_form(%{})), layout: false}
  end

  def handle_event("get_suggestions", %{"search" => search}, socket) do
    # meanings = Bichu.Dict.search(search) |> IO.inspect()
    meanings = [
      %{
        english_entry: "T",
        part_of_speech: "{n}",
        malayalam_definition: "റ്റിയുടെ ആകൃതിയിലുള്ള വസ്തു"
      },
      %{
        english_entry: "T",
        part_of_speech: "{n}",
        malayalam_definition: "ഇംഗ്ലീഷ് അക്ഷരമാലയിലെ ഇരുപതാമത്തെ അക്ഷരം അക്ഷരമാലയിലെ ഇരുപതാമത്തെ അക്ഷരം അക്ഷരമാലയിലെ ഇരുപതാമത്തെ അക്ഷരം"
      },
      %{
        english_entry: "Tb",
        part_of_speech: "{-}",
        malayalam_definition: "ടെറാബൈറ്റ്"
      },
      %{
        english_entry: "To",
        part_of_speech: "{-}",
        malayalam_definition: "ന്നു"
      },
      %{
        english_entry: "To",
        part_of_speech: "{adv}",
        malayalam_definition: "ശരിയായ സ്ഥാനത്തിൽ"
      }
    ]

    socket =
      socket
      |> assign(:meanings, meanings)
      |> assign(:form, to_form(%{search: search}))

    {:noreply, socket}
  end

  def handle_event("show-meaning", %{"english-entry" => eng_entry}, socket) do
    # {:noreply, socket}
    {:noreply, assign(socket, :show_meanings_modal, true)}
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
