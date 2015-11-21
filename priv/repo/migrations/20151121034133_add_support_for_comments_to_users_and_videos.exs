defmodule Rumbl.Repo.Migrations.AddSupportForCommentsToUsersAndVideos do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :annotations, references(:annotations)
    end
    alter table(:videos) do
      add :annotations, references(:annotations)
    end
  end
end
