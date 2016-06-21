defmodule Storex.Index do
  require EEx
  def init(_type, req, args) do
    {:ok, req, args}
  end
  def handle(req, state) do
    result = template("George")
    {:ok, req} = :cowboy_req.reply(200, [{"document-type", "text/html"}], result, req)
    {:ok, req, state}
  end
  def terminate(_reason, _req, _state) do
    :ok
  end
  EEx.function_from_file :defp, :template, "templates/index.eex", [:who]
end