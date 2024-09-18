defmodule BichuWeb.MeaningList do
  use BichuWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="p-4 bg-white rounded-lg shadow-md">
      <ul>
        <%!-- <%= for meaning <- @meanings do %>
          <li>
            <div class="flex items-center">
              <div class="flex-1">
                <div class="text-lg font-semibold"><%= meaning.english_entry %></div>
                <div class="text-sm text-gray-500"><%= meaning.part_of_speech %></div>
              </div>
              <div class="text-sm text-gray-500"><%= meaning.malayalam_definition %></div>
            </div>
          </li>
        <% end %> --%>
      </ul>
      <.modal id="confirm-modal">
        This is a modal.
      </.modal>
    </div>
    """
  end
end
