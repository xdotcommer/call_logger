class AddApcoCodeDescriptionAndNotesToCalls < ActiveRecord::Migration[8.0]
  def change
    add_column :calls, :apco_code, :string
    add_column :calls, :apco_description, :string
    add_column :calls, :apco_notes, :string
  end
end
