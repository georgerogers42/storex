defmodule Storex.Articles do
  use GenServer
  use Timex

  def start_link do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def articles do
    GenServer.call(__MODULE__, :articles)
  end

  def article(slug) do
    GenServer.call(__MODULE__, {:article, slug})
  end
  
  defstruct article_list: [], article_map: %{}
  
  def init([]) do
    articles = load_articles
    {:ok, articles}
  end
  def handle_call(:articles, _from, state) do
    {:reply, {:ok, state.article_list}, state}
  end
  def handle_call({:article, name}, _from, state) do
    {:reply, Map.fetch(state.article_map, name), state}
  end

  defp load_articles(dir \\ "articles") do
    article_list = File.ls!(dir) |> Stream.filter(&Regex.match?(~r(\.html$), &1)) |> Enum.map(&load_article(dir, &1)) |> Enum.sort(&Timex.after?(Map.fetch!(&1, "posted"), Map.fetch!(&2, "posted")))
    %Storex.Articles{article_list: article_list, article_map: article_map(article_list)}
  end
  defp load_article(dir, fname) do
    [meta|content] = File.stream!(dir <> "/" <> fname) |> Stream.chunk_by(&(&1 === "\n")) |> Enum.to_list
    {:ok, mdata} = Poison.decode(meta)
    mdata = Map.put(mdata, "contents", to_string content)
    mdata = Map.put(mdata, "posted", Timex.parse!(Map.fetch!(mdata, "date"), "{ISO:Extended}"))
  end
  defp article_map(lst) do
    Stream.map(lst, &{Map.fetch!(&1, "slug"), &1}) |> Enum.into(%{})
  end
end
