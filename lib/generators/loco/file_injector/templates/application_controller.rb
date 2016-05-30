  include Loco::Emitter

  def loco_permissions
    # specify an array of method names which you use to determine
    # if given resource is signed-in
    # e.g.
    # [current_user, current_admin]
    []
  end

