class AddParamToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :padel_level, :float
    add_column :users, :age, :integer
    add_column :users, :weight, :float
    add_column :users, :height, :integer
    add_column :users, :hand_position, :string
  end
end
