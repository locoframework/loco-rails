# TODO: remove unnecessary
App.I18n.en =
  variants: {}
  models: {}
  attributes: {}
  date:
    formats:
      # Use the strftime parameters for formats.
      # When no format has been given, it uses default.
      # You can provide other formats here if you like!
      default: "%Y-%m-%d"
      short: "%b %d"
      long: "%B %d, %Y"

    day_names: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    abbr_day_names: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

    month_names: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    abbr_month_names: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    # Used in date_select and datetime_select.
    #order: ['year', 'month', 'day']
  errors:
    # The default format to use in full error messages.
    #format: "%{attribute} %{message}"

    # The values :model, :attribute and :value are always available for interpolation
    # The value :count is available when applicable. Can be used for pluralization.
    messages:
      #model_invalid: "Validation failed: %{errors}"
      inclusion: "is not included in the list"
      exclusion: "is reserved"
      invalid: "is invalid"
      confirmation: "doesn't match %{attribute}"
      accepted: "must be accepted"
      empty: "can't be empty"
      blank: "can't be blank"
      present: "must be blank"
      too_long:
        one: "is too long (maximum is 1 character)"
        other: "is too long (maximum is %{count} characters)"
      too_short:
        one: "is too short (minimum is 1 character)"
        other: "is too short (minimum is %{count} characters)"
      wrong_length:
        one: "is the wrong length (should be 1 character)"
        other: "is the wrong length (should be %{count} characters)"
      not_a_number: "is not a number"
      not_an_integer: "must be an integer"
      greater_than: "must be greater than %{count}"
      greater_than_or_equal_to: "must be greater than or equal to %{count}"
      equal_to: "must be equal to %{count}"
      less_than: "must be less than %{count}"
      less_than_or_equal_to: "must be less than or equal to %{count}"
      other_than: "must be other than %{count}"
      odd: "must be odd"
      even: "must be even"