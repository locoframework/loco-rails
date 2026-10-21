# frozen_string_literal: true

module Loco
  module Helpers
    # `data-as-of` is the snapshot's position on the same clock as a notification's
    # `loco.sync_time` — both trail the real moment by Fetcher::OVERLAP — so the
    # client can tell which notifications this snapshot already includes, and
    # replay the ones it does not, without any arithmetic of its own.
    # Falls back to now when nothing captured a request start — a view rendered
    # outside an ActionController::Base request has no live page to reconcile.
    def loco_model_records(name, records, as_of: Loco::Current.as_of || Time.current)
      # json_escape is what makes this safe: it turns <, > and & into their
      # \u escapes, so nothing in the data can close the script tag.
      # rubocop:disable Rails/OutputSafety
      tag.script json_escape(records.to_json).html_safe,
                 # rubocop:enable Rails/OutputSafety
                 type: 'application/json',
                 data: { model: name, as_of: (as_of - Notification::Fetcher::OVERLAP).iso8601(6) }
    end
  end
end
