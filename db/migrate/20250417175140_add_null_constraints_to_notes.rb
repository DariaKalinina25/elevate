# frozen_string_literal: true

# Adds NOT NULL constraint to title and content in notes table
class AddNullConstraintsToNotes < ActiveRecord::Migration[8.0]
  def change
    change_table :notes, bulk: true do |t|
      t.change_null :title, false
      t.change_null :content, false
    end
  end
end
