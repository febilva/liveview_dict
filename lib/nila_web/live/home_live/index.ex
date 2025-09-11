defmodule OlamWeb.HomeLive do
  use OlamWeb, :live_view
  alias OlamWeb.SeoHelpers

  def mount(params, _session, socket) do
    # Check if there's a search query in URL params
    search_query = params["q"]

    socket =
      socket
      |> assign(:meanings, [])
      |> assign(:show_attribution, false)
      |> assign(:current_search, search_query)

    # If there's a search query, perform the search and set SEO data
    socket = if search_query && String.trim(search_query) != "" do
      meanings = Olam.Dict.search(%{"query" => search_query})

      socket
      |> assign(:meanings, meanings)
      |> assign(:form, to_form(%{search: %{query: search_query}}))
      |> assign_seo_data(search_query, meanings)
    else
      socket
      |> assign(:form, to_form(%{}))
      |> assign_default_seo_data()
    end

    {:ok, socket, layout: false}
  end

  defp assign_seo_data(socket, search_query, meanings) do
    # Get first result for SEO
    first_result = case meanings do
      [{english_word, meanings_list} | _] -> {english_word, meanings_list}
      [] -> {search_query, []}
      _ -> {search_query, []}
    end

    {english_word, meanings_list} = first_result

    socket
    |> assign(:page_title, SeoHelpers.word_page_title(english_word, meanings_list))
    |> assign(:meta_description, SeoHelpers.word_meta_description(english_word, meanings_list))
    |> assign(:canonical_url, "https://niladict.in?q=#{URI.encode(search_query)}")
    |> assign(:current_word, english_word)
    |> assign(:structured_data, if(length(meanings_list) > 0, do: SeoHelpers.dictionary_entry_json_ld(english_word, meanings_list), else: nil))
  end

  defp assign_default_seo_data(socket) do
    socket
    |> assign(:page_title, "Nila Malayalam Dictionary")
    |> assign(:meta_description, "Free online English to Malayalam dictionary. നിള മലയാളം നിഘണ്ടു - Find Malayalam meanings for English words. Perfect for Kerala students, professionals and Malayalam learners worldwide.")
    |> assign(:canonical_url, "https://niladict.in")
    |> assign(:current_word, nil)
    |> assign(:structured_data, nil)
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
