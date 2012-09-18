class CreateSaveableOpenResponses < ActiveRecord::Migration
  def change
    create_table :saveable_open_responses do |t|
      # hard-wiring the learner for the dummy app
      t.integer     :learner_id,  :default => 1
      t.integer     :open_response_id
      t.integer     :offering_id
      t.integer     :response_count,   :default => 0
      t.timestamps
    end

    create_table :saveable_open_response_answers do |t|
      t.integer     :open_response_id
      # t.integer     :bundle_content_id
      t.integer     :position
      t.text        :answer
      t.timestamps
    end
    
  end
end
