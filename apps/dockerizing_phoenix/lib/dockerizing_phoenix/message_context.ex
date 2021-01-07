defmodule DockerizingPhoenixWeb.MessageContext do
  @moduledoc false
  @topic "messages"

  def subscribe() do
    Phoenix.PubSub.subscribe(DockerizingPhoenix.PubSub, @topic)
  end

  def broadcast(message) do
    Phoenix.PubSub.broadcast(
      DockerizingPhoenix.PubSub,
      @topic,
      {:message_sent, message}
    )
  end
end
