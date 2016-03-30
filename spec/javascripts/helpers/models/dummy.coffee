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
    dumbAttrib:
      validations:
        length: {within: [0, 1]}
    dumbAttrib2:
      validations:
        length: {within: [2, 4]}
    dumbAttrib3:
      validations:
        length: {is: 5}
    dumbAttrib4:
      validations:
        length: {is: 100}
    blankAttrib:
      validations:
        absence: true

  constructor: (data) -> super data