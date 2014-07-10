class CreateFish < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :fish_name
      t.string :wiki_link
    end
  end

  def down
    # add reverse migration code here
  end
end
