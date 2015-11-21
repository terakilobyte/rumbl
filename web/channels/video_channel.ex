defmodule Rumbl.VideoChannel do
	use Rumbl.Web, :channel
  alias Rumbl.AnnotationView

  def join("videos:" <> video_id, _params, socket) do
    case Integer.parse(video_id) do
      {int, _} ->
        video = Repo.get!(Rumbl.Video, video_id)
        annotations = Repo.all(
          from a in assoc(IO.inspect(video), :annotations),
          order_by: [desc: a.at],
          limit: 200,
          preload: [:user]
        )
        resp = %{annotations: Phoenix.View.render_many(annotations, AnnotationView, "annotation.json")}
        {:ok, resp, assign(socket, :video_id, int)}
      _ ->
        {:error}
    end
  end

  def handle_in(event, params, socket) do
    user = Repo.get(Rumbl.User, socket.assigns.user_id)
    handle_in(IO.inspect(event), params, IO.inspect(user), socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    changeset =
      IO.inspect(user)
    |> build(:annotations, video_id: socket.assigns.video_id)
    |> Rumbl.Annotation.changeset(params)

    case Repo.insert(changeset) do
      {:ok, annotation} ->
        broadcast! socket, "new_annotation",
        %{
          user: Rumbl.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        }
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
