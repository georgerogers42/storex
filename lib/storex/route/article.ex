defmodule Storex.Route.Article do
  require EEx
  def init(_type, req, view) do
    {:ok, req, view}
  end
  def handle(req, view) do
    {slug, req} = :cowboy_req.binding(:slug, req)
    {:ok, article} = Storex.Articles.article(slug)
    result = view.template(article)
    {:ok, req} = :cowboy_req.reply(200, [{"document-type", "text/html"}], result, req)
    {:ok, req, view}
  end
  def terminate(_reason, _req, _state) do
    :ok
  end
  EEx.function_from_file :def, :template, "templates/article.eex", [:article]
end
