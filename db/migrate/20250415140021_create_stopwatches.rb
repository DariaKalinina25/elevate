# frozen_string_literal: true

class CreateStopwatches < ActiveRecord::Migration[8.0]
  def change
    create_table :stopwatches do |t|
      t.string :title, null: false
      t.datetime :started_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :stopped_at
      t.integer :status, default: 0, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
