class AddNameAndImageUrlToTrainings < ActiveRecord::Migration[8.1]
  def change
    add_column :trainings, :name, :string
    add_column :trainings, :image_url, :string
    add_column :trainings, :maestro_conseil, :text
  end
end
