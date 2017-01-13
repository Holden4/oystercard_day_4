require './lib/journey'

class Oystercard

  MAX_BALANCE = 90
  MIN_FARE = 1

  attr_reader :balance, :history, :current_journey

  def initialize
    @balance = 0
    @history = []
    @current_journey = nil
  end

  def top_up(amount)
    exceed_max_balance!(amount)
    @balance += amount
  end

  def touch_in(entry_station)
      sufficient_funds!
    if in_journey?
       deduct(current_journey.fare)
       write_to_history
    end
      @current_journey = Journey.new(entry_station)
  end

  def touch_out(exit_station)
      @current_journey = Journey.new(nil) unless in_journey?
      @current_journey.exit_station = exit_station
       deduct(current_journey.fare)
       write_to_history
      @current_journey = nil
    end

  def in_journey?
    current_journey != nil
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def exceed_max_balance!(amount)
    error_message = "Your card's balance cannot exceed £#{MAX_BALANCE}."
    raise error_message if @balance + amount > MAX_BALANCE
  end

  def sufficient_funds!
    error_message = "Insufficient funds for the journey."
    raise error_message if @balance < MIN_FARE
  end

  def write_to_history
    history << { entry_station: current_journey.entry_station,  exit_station: current_journey.exit_station }
  end


end
