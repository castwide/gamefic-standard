class Gamefic::Entity
  include Grammar::Attributes
  include Standardized
end

Thing = Gamefic::Entity
Thing.set_default itemized: true, portable: false
