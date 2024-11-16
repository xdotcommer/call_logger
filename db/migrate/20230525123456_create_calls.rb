class CreateCalls < ActiveRecord::Migration[6.1]
  def change
    create_table :calls do |t|
      t.string :incident_number, null: false, unique: true
      t.string :call_type, null: false
      t.string :call_type_group, null: false
      t.datetime :call_time, null: false
      t.string :street
      t.string :call_origin, null: false
      t.boolean :mental_health, default: false
      t.boolean :drug_related, default: false
      t.boolean :dv_related, default: false
      t.boolean :alcohol_related, default: false
      t.string :area, null: false
      t.string :area_name, null: false
      t.decimal :latitude, null: false, precision: 10, scale: 6
      t.decimal :longitude, null: false, precision: 10, scale: 6
      t.string :hour, null: false
      t.string :day_of_week, null: false
      t.integer :ward
      t.string :district, null: false
      t.string :priority, null: false
      t.string :month, null: false
      t.integer :year, null: false

      t.timestamps
    end
  end
end
