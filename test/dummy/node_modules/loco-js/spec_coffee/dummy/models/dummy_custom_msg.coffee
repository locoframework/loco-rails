class App.Models.DummyCustomMsg extends App.Models.Base
  @identity = "DummyCustomMsg"

  @attributes =
    title:
      validations:
        presence: {message: 'presence is required'}
        length: {minimum: 1, maximum: 255}
    letter:
      validations:
        length: {is: 1}
    lang:
      validations:
        length: {is: 2, message: 'length is not what I expect'}
    shortDesc:
      validations:
        length: {minimum: 10, maximum: 50, message: 'length is bloody wrong'}
    author:
      validations:
        exclusion: {in: ['admin', 'superadmin'], message: 'being an admin is not for u'}
    rate:
      validations:
        inclusion: {within: ['bad', 'good', 'excellent'], message: 'value is not good'}
    countryCode:
      validations:
        format: {with: /^[A-Z]{2}$/, message: 'invalid country code'}
    year:
      validations:
        numericality:
          only_integer: true
          greater_than: 1887
          less_than_or_equal_to: (o) -> o.releaseYear
          message: 'your number is not acceptable'
    releaseYear:
      validations:
        numericality:
          only_integer: true
          greater_than_or_equal_to: new Date().getFullYear()
          less_than: 2100
          other_than: 2098
    accessPassword:
      validations:
        confirmation: {message: 'different than confirmation'}
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
    blankAttrib:
      validations:
        absence: {message: 'only blank dude'}

  constructor: (data) -> super data