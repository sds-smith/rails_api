class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.text :title
      t.text :price
      t.text :category
      t.text :description
      t.text :image

      t.timestamps
    end
  end
end
