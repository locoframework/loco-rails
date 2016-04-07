class App.Validators.Size extends App.Validators.Base
  constructor: -> super

  validate: -> App.Validators.Length.instance(@obj, @attr, @opts).validate()