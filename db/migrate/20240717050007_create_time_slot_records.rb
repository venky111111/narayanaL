class CreateTimeSlotRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :time_slot_records do |t|
      t.date :date

      t.timestamps
    end
  end
end
