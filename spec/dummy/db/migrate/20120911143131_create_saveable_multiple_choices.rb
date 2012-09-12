class CreateSaveableMultipleChoices < ActiveRecord::Migration
  def change
    create_table :saveable_multiple_choices do |t|
      # t.integer     :learner_id
      t.integer     :offering_id
      t.integer     :multiple_choice_id
      t.integer     :response_count,     :default => 0
      t.timestamps
    end

    create_table :saveable_multiple_choice_answers do |t|
      t.integer     :multiple_choice_id
      # t.integer     :bundle_content_id
      t.integer     :choice_id
      t.integer     :position
      t.timestamps
    end
  end
end
