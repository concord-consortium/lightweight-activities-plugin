class CreatePortalOfferings < ActiveRecord::Migration
  def change
    create_table :portal_offerings do |t|
      t.string   :uuid,               :limit => 36
      t.string   :status
      # t.integer  :clazz_id
      t.integer  :runnable_id
      t.string   :runnable_type
      t.datetime :created_at,         :null => false
      t.datetime :updated_at,         :null => false
      t.boolean  :active,             :default => true
      # t.boolean  :default_offering,   :default => false
      t.integer  :position,           :default => 0

      t.timestamps
    end

    add_column :lightweight_lightweight_activities, :offerings_count, :integer
    add_column :lightweight_interactive_pages, :offerings_count, :integer
  end
end
