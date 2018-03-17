class Vehicle
  def initialize(engine, propellers)
    @engine = engine
    @propellers = propellers
  end

  attr_reader :engine, :propellers

  def drive
    engine.start
    engine.move_forward(10)
    engine.stop
  end
end

class Engine
  def start
    puts 'Start your engines!'
  end

  def move_forward(distance)
    puts "Moving forward #{distance}"
  end

  def stop
    puts 'A large explosion appears on the horizon'
  end
end

class Propellers
  def start
    puts 'A loud clickity-clackity noise fills your ears'
  end

  def move_forward(distance)
    puts "You do nothing for #{distance}"
  end

  def stop
    puts 'I hope you put the landing gear down'
  end
end

require '../lib/guardrails'
car_spec = Guardrails::Specification.new(Vehicle, :has_engine, proc { |vehicle| vehicle.engine })
plane_spec = Guardrails::Specification.new(Vehicle, :has_propeller, proc { |vehicle| vehicle.propellers})

railings = Guardrails::Railing.new([car_spec, plane_spec])

just_car_outcome = railings.check_specs do
  'some other setup to be ignored'
  Vehicle.new(Engine.new, nil)
end
puts "When only a car is created: #{just_car_outcome}"

just_plane_outcome = railings.check_specs do
  Vehicle.new(nil, Propellers.new)
end
puts "When only a plane is created: #{just_plane_outcome}"

all_specs_fulfilled_outcome = railings.check_specs do
  Vehicle.new(Engine.new, nil)
  Vehicle.new(nil, Propellers.new)
end
puts "When all expected kinds of vehicles are created: #{all_specs_fulfilled_outcome}"
