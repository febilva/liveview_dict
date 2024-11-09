defmodule HomeLiveTest do
  use OlamWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "/" do
    test "mounts the live view", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      assert has_element?(view, "p", "OLAM")
    end
  end

  test "renders a search form", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    # Assert that the form contains the label "Search"
    assert has_element?(view, "label", "Search")

    # Assert that the form contains an input field for search
    assert has_element?(view, "input[name='search']")
  end

  test "renders a search button", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    # Assert that the form contains a button with the text "Search"
    assert has_element?(view, "button", "Search")
  end

  test "search submit form with a word", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    view
      |> form("#dict-search", search: "tiger")
      |> render_submit() =~ "tigo"
  end

  test "render results for a word", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    view
      |> form("#dict-search", search: ".net")
      |> render_submit()

      open_browser(view)
    assert has_element?(view, "p", ".net")
  end
  # test "mounts the live view", %{conn: conn} do

  #
  #     conn= get(conn, "/")
  #   assert html_response(conn, 200) =~ "OLAM"
  # end
end
