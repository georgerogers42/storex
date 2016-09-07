defmodule Storex.Route.Index do
  require EEx
  def init(_type, req, view) do
    {:ok, req, view}
  end
  def handle(req, view) do
    {:ok, articles} = Storex.Articles.articles
    result = view.template(articles)
    {:ok, req} = :cowboy_req.reply(200, [{"document-type", "text/html"}], result, req)
    {:ok, req, view}
  end
  def terminate(_reason, _req, _state) do
    :ok
  end
  EEx.function_from_file :def, :template, "templates/index.eex", [:articles]
end
