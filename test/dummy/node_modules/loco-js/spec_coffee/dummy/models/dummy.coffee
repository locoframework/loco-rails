class App.Models.Dummy extends App.Models.Base
  @identity = "Dummy"

  @attributes =
    title:
      validations:
        length: {minimum: 1, maximum: 255}
    letter:
      validations:
        length: {is: 1}
    lang:
      validations:
        length: {is: 2}
    shortDesc:
      validations:
        length: {minimum: 10, maximum: 50}
    author:
      validations:
        exclusion: {in: ['admin', 'superadmin']}
    rate:
      validations:
        inclusion: {within: ['bad', 'good', 'excellent']}
    year:
      validations:
        numericality:
          only_integer: true
          greater_than: 1887
          less_than_or_equal_to: (o) -> o.releaseYear
    releaseYear:
      validations:
        numericality:
          only_integer: true
          greater_than_or_equal_to: new Date().getFullYear()
          less_than: 2100
          other_than: 2098
    dumbAttrib:
      validations:
        length: {within: [0, 1]}
        numericality: {equal_to: 5}
    dumbAttrib2:
      validations:
        length: {within: [2, 4]}
        numericality: {odd: true}
    dumbAttrib3:
      validations:
        length: {is: 5}
        numericality: {even: true}
    dumbAttrib4:
      validations:
        length: {is: 100}
    dumbAttrib5:
      validations:
        size: {minimum: 1}
        format:
          with: /^[a-z0-9]{5,}$/
          if: (o) -> o.dumbAttrib5? and o.dumbAttrib5.length >= 5
    blankAttrib:
      validations:
        absence: true

  constructor: (data) -> super data