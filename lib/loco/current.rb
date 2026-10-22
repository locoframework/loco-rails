# frozen_string_literal: true

module Loco
  # captured before a controller action runs any query -> `as_of` is never later
  # than the data a snapshot rendered from that action contains
  class Current < ActiveSupport::CurrentAttributes
    attribute :as_of
  end
end
