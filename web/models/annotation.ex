defmodule Rumbl.Annotation do
  use Rumbl.Web, :model

  schema "annotations" do
    field :body, :string
    field :at, :integer
    belongs_to :user, Rumbl.User
    belongs_to :video, Rumbl.Video

    timestamps
  end

  @required_fields ~w(body at)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
