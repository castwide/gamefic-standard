# frozen_string_literal: true

Character = Gamefic::Actor
Character.set_default gender: :other
Character.include Gamefic::What::Askable
