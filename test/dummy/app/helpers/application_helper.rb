# frozen_string_literal: true

module ApplicationHelper
  def simplicit_body_attrs
    namespace = controller_path
                .split('/')
                .then { |parts| parts[0...-1] } # everything except the controller name
                .map(&:camelize)
                .join('/')
    {
      data: {
        namespace: namespace.presence,           # -> data-namespace="Main/Panel"
        controller: controller_name.camelize,    # -> data-controller="Articles"
        action: action_name                      # -> data-action="index"
      }.compact
    }
  end

  def admin_panel?
    controller_path.split('/').first == 'admin'
  end

  def user_panel?
    controller_path.split('/').first == 'user'
  end

  def body_styles
    if admin_panel?
      'background-color: #99734B;'
    elsif user_panel?
      'background-color: #73994B;'
    else
      ''
    end
  end
end
