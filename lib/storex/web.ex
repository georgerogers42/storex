defmodule Storex.Web do
  import Logger
  def port(default \\ "8080") do
    String.to_integer(System.get_env("PORT") || default)
  end
  def routes do
    [{"/", Storex.Route.Index, Storex.Route.Index},
     {"/article/:slug", Storex.Route.Article, Storex.Route.Article},
     {"/static/[...]", :cowboy_static, {:priv_dir, :storex, "static"}}]
  end
  def start_link do
    p = port
    dispatch = :cowboy_router.compile([_: routes])
    res = :cowboy.start_http(:storex, 100, [port: p], [env: [dispatch: dispatch]])
    log(:info, "Listening on port: " <> to_string p)
    res
  end
end
