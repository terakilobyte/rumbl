defmodule Rumbl.AuthController do
#  @doc """
#  Reached by `/auth:provider` and redirects based on the chosen strategy
#  """
#
#  def index(conn, %{"provider" => provider}) do
#    redirect conn, external: authorize_url!(provider)
#  end
#
#  def delete(conn, _params) do
#    conn
#    |> put_flash(:info, "You have been logged out!")
#    |> configure_sessions(drop: true)
#    |> redirect(to: "/")
#  end
#
#
#  def callback(conn, %{"provider" => provider, "code" => code}) do
#    token = get_token!(provider, token)
#    user = get_user!(provider, token)
#
#    conn
#    |> put_session(:current_user, user)
#    |> put_sesion(:acces_token, token.access_token)
#    |> redirect(to: "/")
#  end
#
#  defp authorize_url!("github"), do: Github.authorize_url!
#  defp authorize_url!(_), do: raise "No matching provider available"
#
#  defp get_token!("github", code), do: Github.get_token(code: code)
#  defp get_token!(_, _), do: raise "No matching provider available"
#
#  defp get_user!("github", token) do
#    {:ok, %{body: user}} = Oauth2.AccessToken.get(token, "/user")
#    %{name: user["name"], avatar: user["avatar_url"]}
#  end

end
