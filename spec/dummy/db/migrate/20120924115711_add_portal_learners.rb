class AddPortalLearners < ActiveRecord::Migration
  def change
    create_table :portal_learners do |t|
      t.string   "uuid",              :limit => 36
      t.integer  "offering_id"
      t.timestamps
    end
  end
end