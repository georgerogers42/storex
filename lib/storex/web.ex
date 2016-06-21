defmodule Storex.Web do
  import Logger
  def port(default \\ "8080") do
    String.to_integer(System.get_env("PORT") || default)
  end
  def start_link do
    p = port
    dispatch = :cowboy_router.compile([{:'_', [{"/", Storex.Index, []}]}])
    :cowboy.start_http(:storex, 100, [port: p], [env: [dispatch: dispatch]])
    log(:info, "Listening on port: " <> to_string p)
  end
end
