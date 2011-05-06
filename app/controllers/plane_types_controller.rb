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

  filter :combo, lambda { |r| apply_search_to_relation(r, [ 'name' ]) }

end
