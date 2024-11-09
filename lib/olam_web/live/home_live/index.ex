defmodule OlamWeb.HomeLive do
  use OlamWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :meanings, [])


    {:ok, assign(socket, :form, to_form(%{}))}
  end

  def handle_event("get_suggestions", %{"search" => search}, socket) do
    # meanings = Olam.Dict.search(search) |> IO.inspect()
    meanings = [
      %{
        english_entry: "T",
        part_of_speech: "{n}",
        malayalam_definition: "റ്റിയുടെ ആകൃതിയിലുള്ള വസ്തു അക്ഷരമാലയിലെ ഇരുപതാമത്തെ അക്ഷരം"
      },
      %{
        english_entry: "T",
        part_of_speech: "{n}",
        malayalam_definition: "ഇംഗ്ലീഷ് അക്ഷരമാലയിലെ ഇരുപതാമത്തെ അക്ഷരം അക്ഷരമാലയിലെ ഇരുപതാമത്തെ അക്ഷരം"
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
end
