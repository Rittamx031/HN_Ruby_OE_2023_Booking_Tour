class AddSlugToTours < ActiveRecord::Migration[7.0]
  def change
    add_column :tours, :slug, :string
    add_index :tours, :slug, unique: true
  end
end
