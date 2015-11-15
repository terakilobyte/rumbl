defmodule Rumbl.Repo.Migrations.CreateVideo do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :" url", :string
      add :title, :string
      add :description, :text
      add :user_id, references(:users)

      timestamps
    end
    create index(:videos, [:user_id])

  end
end
