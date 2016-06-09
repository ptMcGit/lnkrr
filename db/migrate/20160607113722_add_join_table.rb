class AddJoinTable < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
    end

    create_table :item_tags do |t|
      t.integer :item_id
      t.integer :category_id
    end
  end
end
