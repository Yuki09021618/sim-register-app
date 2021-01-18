class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.string :imsi
      t.string :devicesn

      t.timestamps
    end
  end
end
