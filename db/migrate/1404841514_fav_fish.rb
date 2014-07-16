class FavFish < ActiveRecord::Migration
  def up
    create_table :favorite do |t|
      t.integer :fish_id
      t.integer :user_id
    end
  end

  def down
    # add reverse migration code here
  end
end
