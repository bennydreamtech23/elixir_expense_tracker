defmodule ExpenseTracker.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :name, :string
      add :description, :string
      add :category, :string
      add :account_type, :string
      add :amount, :float

      timestamps(type: :utc_datetime)
    end
  end
end
