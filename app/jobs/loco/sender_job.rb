# frozen_string_literal: true

module Loco
  # jobs enqueued under the old name before an upgrade still load and run
  SenderJob = ActiveSupport::Deprecation::DeprecatedConstantProxy.new(
    'Loco::SenderJob', 'Loco::BroadcastJob', DEPRECATOR
  )
end
