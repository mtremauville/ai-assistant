class CreateTrainings < ActiveRecord::Migration[8.1]
  def change
    create_table :trainings do |t|
      t.integer :duration
      t.string :type
      t.integer :intensity
      t.integer :team_size
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :chat, null: false, foreign_key: true
      t.integer :feedback_rating

      t.timestamps
    end
  end
end
