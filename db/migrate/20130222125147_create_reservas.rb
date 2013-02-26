class CreateReservas < ActiveRecord::Migration
  def change
    create_table :reservas do |t|
      t.integer :cancha
      t.datetime :fdesde
      t.datetime :fhasta
      t.string :players

      t.timestamps
    end
  end
end
