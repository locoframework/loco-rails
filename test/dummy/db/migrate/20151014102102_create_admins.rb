class CreateAdmins < ActiveRecord::Migration[4.2]
  def change
    create_table :admins do |t|
      t.string :email
      t.string :password_digest

      t.timestamps null: false, limit: 6
    end
  end
end
