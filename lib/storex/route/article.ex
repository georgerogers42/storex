defmodule Storex.Route.Article do
  require EEx
  def init(_type, req, args) do
    {:ok, req, args}
  end
  def handle(req, state) do
    {slug, req} = :cowboy_req.binding(:slug, req)
    {:ok, article} = Storex.Articles.article(slug)
    result = template([article])
    {:ok, req} = :cowboy_req.reply(200, [{"document-type", "text/html"}], result, req)
    {:ok, req, state}
  end
  def terminate(_reason, _req, _state) do
    :ok
  end
  EEx.function_from_file :defp, :template, "templates/index.eex", [:articles]
end
