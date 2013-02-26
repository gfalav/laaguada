class Reserva < ActiveRecord::Base
  attr_accessible :cancha, :fdesde, :fhasta, :players
end
