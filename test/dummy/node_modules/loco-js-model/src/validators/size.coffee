import Base from './base.coffee'
import Length from './length.coffee'

class Size extends Base
  @identity = "Size"

  constructor: -> super()

  validate: -> Length.instance(@obj, @attr, @opts).validate()

export default Size