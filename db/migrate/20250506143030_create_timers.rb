# frozen_string_literal: true

# This migration creates the timers table with fields for title, start and stop times,
# duration, status, and a reference to the user who owns the timer.
class CreateTimers < ActiveRecord::Migration[8.0]
  def change
    create_table :timers do |t|
      t.string :title, null: false
      t.datetime :started_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.integer :duration_seconds, null: false
      t.datetime :stopped_at
      t.integer :status, default: 0, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
