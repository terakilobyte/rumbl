defmodule Rumbl.InfoSys.Wolfram do
  import SweetXml
  import Ecto.Query, only: [from: 2]
  alias Rumbl.InfoSys.Result

  def start_link(query, query_ref, owner, limit) do
    Task.start_link(__MODULE__, :fetch, [query, query_ref, owner, limit])
  end


  def fetch("wolfram: " <> query_str, query_ref, owner, _limit) do
    query_str
    |> fetch_xml()
    |> get_pod
    |> send_results(query_ref, owner)
  end

  def fetch(_, query_ref, owner, _) do
    send_results(nil, query_ref, owner)
  end

  defp get_pod(xml) do
    xpath(xml, ~x"//queryresult/pod[contains(@title, 'Result')]
    /subpod/plaintext/text()")
    ||
    xpath(xml, ~x"//queryresult/pod[contains(@title, 'Definitions')]
    /subpod/plaintext/text()")
  end

  defp send_results(nil, query_ref, owner) do
    send(owner, {:results, query_ref, []})
  end
  defp send_results(answer, query_ref, owner) do
    results = [%Result{backend: user(), score: 95, text: to_string(answer)}]
    send(owner, {:results, query_ref, results})
  end

  defp fetch_xml(query_str) do
    url = "http://api.wolframalpha.com/v2/query?" <>
      "input=#{IO.inspect(URI.encode_www_form(query_str))}&" <>
      "appid=#{app_id()}&" <>
      "format=plaintext"
    HTTPoison.request!(:get, url, "", [], [recv_timeout: 30_000, timeout: 30_000]).body
  end

  defp app_id, do: Application.get_env(:rumbl, :wolfram)[:app_id]

  defp user() do
    Rumbl.Repo.one!(from u in Rumbl.User, where: u.username == "wolfram")
  end
end
