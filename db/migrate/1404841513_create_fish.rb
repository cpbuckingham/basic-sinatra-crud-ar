class CreateFish < ActiveRecord::Migration
  def up
    create_table :fish do |t|
      t.string :fish_name
      t.string :wiki_link
      t.integer :user_id
    end
  end

  def down
    # add reverse migration code here
  end
end