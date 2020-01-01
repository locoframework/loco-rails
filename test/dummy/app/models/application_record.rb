# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Ephemeron::ModelAddons

  self.abstract_class = true
end
