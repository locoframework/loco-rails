module CapybaraOffline
  def go_disconnected disconnected_mode = :server_error
    if Rails.version.to_i >= 5
      page.evaluate_script "App.Channels.Loco.NotificationCenter.disconnected();"
    end
    current_proxy = NoResponseRack.new disconnected_mode
    rack_mappings.unshift [nil, "", /^(.*)/n, current_proxy]
  end

  def go_connected
    if Rails.version.to_i >= 5
      page.evaluate_script "App.Channels.Loco.NotificationCenter.connected();"
    end
    rack_mappings.shift
  end

  def rack_app
    Capybara::current_session.driver.app
  end

  def rack_mappings
    rack_app.instance_variable_get(:@mapping)
  end
end