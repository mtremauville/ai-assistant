class RenameTypeColumnToTrainingType < ActiveRecord::Migration[8.1]
  def change
    rename_column :trainings, :type, :training_type
  end
end
