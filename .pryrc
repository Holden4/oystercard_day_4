require_relative './lib/oystercard.rb'
require_relative './lib/station.rb'
require_relative './lib/journey.rb'

card1 = Oystercard.new
card1.top_up(10)
puts "#{card1.balance}"

card2 = Oystercard.new
card1.top_up(50)
puts "#{card2.balance}"

bank = Station.new("bank")
victoria = Station.new("victoria")
