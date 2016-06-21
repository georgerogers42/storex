defmodule Storex.Articles do
  use GenServer
  def start_link do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
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
    article_list = File.ls!(dir) |> Stream.filter(&Regex.match(~r(\.html$), &1)) |> Enum.map(&load_article/1)
    %Storex.Articles{article_list: article_list, article_map: article_map(article_list)}
  end
  defp load_article(fname) do
    [meta|content] = File.stream!(fname) |> Stream.chunk_by(&(&1 === "\n")) |> Enum.to_list
    {:ok, mdata} = Poison.decode(meta)
    %{ mdata | "contents" => content}
  end
  defp article_map(lst) do
    Stream.map(lst, &{Map.fetch!(&1, "slug"), &1}) |> Enum.into(%{})
  end
end
