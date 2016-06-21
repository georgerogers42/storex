defmodule Storex do
  use Application
  def main(_args) do
    receive do
    end
  end
  def start(_kind, _args) do
    {:ok, sup} = Storex.Supervisor.start_link
    Storex.Web.start_link
    {:ok, sup}
  end
end
