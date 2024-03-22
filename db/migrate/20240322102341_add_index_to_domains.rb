class AddIndexToDomains < ActiveRecord::Migration[7.1]
  def change
    add_index :domains, :name, unique: true
  end
end
