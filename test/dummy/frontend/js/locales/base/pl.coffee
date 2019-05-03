App.I18n.pl =
  variants:
    few: (i) ->
      num = parseInt App.Utils.String.last String(i)
      [2,3,4].indexOf(num) isnt -1 and not(String(i).length is 2 && String(i)[0] is '1')
  models: {}
  attributes: {}
  ui:
    form:
      sending: "Wysyłam..."
      success: "Sukces"
      errors:
        connection: "Błąd z połączeniem"
        invalid_data: "Nieprawidłowe dane"
  date:
    formats:
      default: "%d-%m-%Y"
      short: "%d %b"
      long: "%B %d, %Y"
    day_names: ["niedziela", "poniedziałek", "wtorek", "środa", "czwartek", "piątek", "sobota"]
    abbr_day_names: ["nie", "pon", "wto", "śro", "czw", "pią", "sob"]
    month_names: ["styczeń", "luty", "marzec", "kwiecień", "maj", "czerwiec", "lipiec", "sierpień", "wrzesień", "październik", "listopad", "grudzień"]
    abbr_month_names: ["sty", "lut", "mar", "kwi", "maj", "cze", "lip", "sie", "wrz", "paź", "lis", "gru"]
  errors:
    messages:
      accepted: "musi zostać zaakceptowane"
      blank: "nie może być puste"
      confirmation: "nie zgadza się z polem %{attribute}"
      empty: "nie może być puste"
      equal_to: "musi być równe %{count}"
      even: "musi być parzyste"
      exclusion: "jest zarezerwowane"
      greater_than: "musi być większe od %{count}"
      greater_than_or_equal_to: "musi być większe lub równe %{count}"
      inclusion: "nie znajduje się na liście dopuszczalnych wartości"
      invalid: "jest nieprawidłowe"
      less_than: "musi być mniejsze od %{count}"
      less_than_or_equal_to: "musi być mniejsze lub równe %{count}"
      not_a_number: "nie jest liczbą"
      not_an_integer: "musi być liczbą całkowitą"
      odd: "musi być nieparzyste"
      present: "musi być puste"
      too_long:
        few: "jest za długie (maksymalnie %{count} znaki)"
        many: "jest za długie (maksymalnie %{count} znaków)"
        one: "jest za długie (maksymalnie jeden znak)"
        other: "jest za długie (maksymalnie %{count} znaków)"
      too_short:
        few: "jest za krótkie (przynajmniej %{count} znaki)"
        many: "jest za krótkie (przynajmniej %{count} znaków)"
        one: "jest za krótkie (przynajmniej jeden znak)"
        other: "jest za krótkie (przynajmniej %{count} znaków)"
      wrong_length:
        few: "ma nieprawidłową długość (powinna wynosić %{count} znaki)"
        many: "ma nieprawidłową długość (powinna wynosić %{count} znaków)"
        one: "ma nieprawidłową długość (powinna wynosić jeden znak)"
        other: "ma nieprawidłową długość (powinna wynosić %{count} znaków)"
      other_than: "musi być inna niż %{count}"