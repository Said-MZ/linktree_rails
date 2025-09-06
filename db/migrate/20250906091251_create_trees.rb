class CreateTrees < ActiveRecord::Migration[7.2]
  def change
    create_table :trees do |t|
      t.string :name
      t.string :x
      t.string :instagram
      t.string :youtube
      t.string :links
      t.references :user, null: false, foreign_key: true
      t.string :style

      t.timestamps
    end
  end
end
