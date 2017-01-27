class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.string :obj_class
      t.integer :obj_id
      t.string :token

      t.timestamps null: false, limit: 6
    end
  end
end
