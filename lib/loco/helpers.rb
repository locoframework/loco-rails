# frozen_string_literal: true

module Loco
  module Helpers
    def loco_model_records(name, records, as_of: Loco::Current.as_of || Time.current)
      # rubocop:disable-next Rails/OutputSafety -- json_escape turns <, > and & into \u escapes
      tag.script json_escape(records.to_json).html_safe,
                 type: 'application/json',
                 data: { model: name, as_of: (as_of - Notification::Fetch::OVERLAP).iso8601(6) }
    end
  end
end
