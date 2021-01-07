defmodule DockerizingPhoenixWeb.PageLive do
  use DockerizingPhoenixWeb, :live_view
  alias DockerizingPhoenixWeb.MessageContext

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      MessageContext.subscribe()
    end

    {
      :ok,
      assign(
        socket,
        messages: [],
        temporary_assigns: [
          messages: []
        ]
      )
    }
  end

  @impl true
  def handle_event("send_message", %{"message" => message}, socket) do
    MessageContext.broadcast("#{message} from #{node()}")
    {:noreply, socket}
  end

  @impl true
  def handle_info({:message_sent, message}, socket) do
    {
      :noreply,
      assign(
        socket,
        messages: [message | socket.assigns.messages]
      )
    }
  end

  def format_node_name(node_name) when is_atom(node_name), do: Atom.to_string(node_name)
  def format_node_name(node_name), do: node_name

  def format_node_names(node_names) do
    node_names
    |> Enum.map(&format_node_name/1)
    |> Enum.join(", ")
  end
end
