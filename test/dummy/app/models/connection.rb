class Connection < ActiveRecord::Base
  validates :obj_class, presence: true
  validates :obj_id, presence: true

  class << self
    def for_obj obj
      where obj_class: obj.class.name, obj_id: obj.id
    end
  end

  def obj= val
    self.obj_class = val.class.name
    self.obj_id = val.id
  end
end
