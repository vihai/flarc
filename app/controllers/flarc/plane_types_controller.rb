module Flarc
class PlaneTypesController < RestController

  rest_controller_for PlaneType

  view :combo do
    empty!
    attribute(:id) { show! }
    attribute(:name) { show! }
    attribute(:configurations) do
      include!
    end
  end

  def find_targets
    @targets_relation = apply_search_to_relation(model.scoped, [ 'name' ])
    super
  end
end

end
