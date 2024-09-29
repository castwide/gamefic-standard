# frozen_string_literal: true

Thing = Gamefic::Entity
Thing.set_default itemized: true, portable: false
Thing.include Gamefic::Standard::Standardized
