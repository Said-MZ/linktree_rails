class RemoveLinksFromTree < ActiveRecord::Migration[7.2]
  def change
    remove_column :trees, :links, :string
  end
end
