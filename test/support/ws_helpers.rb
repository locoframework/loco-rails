# frozen_string_literal: true

module WsHelpers
  def create_connection(resource, uuid = SecureRandom.uuid)
    Loco::WsConnectionManager.new(resource).add(uuid)
  end

  def setup_connections
    create_connection(users(:zbig), 'UUID#1')
    create_connection(users(:jane), 'UUID#2')
    create_connection(admin_support_members(:one), 'UUID#3')
    create_connection(admin_support_members(:one), 'UUID#3.1')
    create_connection(admin_support_members(:two), 'UUID#4')
    create_connection('comment:980190961', 'UUID#5')
    create_connection('random-token', 'UUID#6')
    Loco::Hub.set('foobar', [users(:zbig), users(:jane)])
  end
end
