class CreateDomains < ActiveRecord::Migration[7.1]
  def change
    create_table :domains do |t|
      t.string :name
      t.string :registrar_name
      t.datetime :registration_date
      t.datetime :expiry_date

      t.timestamps
    end
  end
end
