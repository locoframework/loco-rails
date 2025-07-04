# frozen_string_literal: true

class CreateAdminSupportMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :admin_support_members do |t|
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
