class CreateSoftwares < ActiveRecord::Migration
  def change
    create_table :softwares do |t|
      t.string :name
      t.text :settings
      t.text :other_settings
      t.text :empty_settings

      t.timestamps null: false
    end
  end
end
