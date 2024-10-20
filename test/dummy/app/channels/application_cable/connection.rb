# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :loco_permissions

    def connect
      reject_unauthorized_connection unless current_user || current_admin
      self.loco_permissions = [SecureRandom.uuid, current_user, current_admin]
      logger.add_tags('AC', (loco_permissions.map { |e| e.try(:id) || '-' }))
    end

    protected

    def current_admin
      Admin::SupportMember.find_by(id: cookies.signed[:admin_id])
    end

    def current_user
      User.find_by(id: cookies.signed[:user_id])
    end
  end
end
