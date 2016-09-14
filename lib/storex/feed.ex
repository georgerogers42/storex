defmodule Storex.Feed do
  def template(articles) do
    Poison.encode! articles
  end
end
