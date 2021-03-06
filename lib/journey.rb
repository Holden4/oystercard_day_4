class Journey

attr_accessor :entry_station, :exit_station


  def initialize(entry_station)
    @entry_station = entry_station
    @exit_station = nil
  end

  def complete_journey(exit_station)
    @exit_station = exit_station
  end

  def fare
    entry_station == nil || exit_station == nil ? 6 : 1
  end

end
