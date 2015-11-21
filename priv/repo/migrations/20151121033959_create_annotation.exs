defmodule Rumbl.Repo.Migrations.CreateAnnotation do
  use Ecto.Migration

  def change do
    create table(:annotations) do
      add :body, :text
      add :at, :integer
      add :user_id, references(:users)
      add :video_id, references(:videos)

      timestamps
    end
    create index(:annotations, [:user_id])
    create index(:annotations, [:video_id])

  end
end
