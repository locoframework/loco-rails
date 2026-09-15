# frozen_string_literal: true

module Loco
  # Per-request state. `as_of` is captured before a controller action runs any
  # query, so a snapshot rendered from that action can claim a position on the
  # notification clock that is no later than the data it contains.
  class Current < ActiveSupport::CurrentAttributes
    attribute :as_of
  end
end
