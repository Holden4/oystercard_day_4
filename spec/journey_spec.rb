require './lib/journey'
require './lib/oystercard'

describe Journey do

  let(:entry_station) {double :station}
  let(:exit_station) {double :station}
  subject(:journey) { described_class.new(entry_station) }

  describe '#new start journey' do
    it "stores the entry station" do
      expect(journey.entry_station).to eq entry_station
    end
  end

  describe 'end journey' do
    it "stores the station" do
      journey.complete_journey(exit_station)
      expect(journey.exit_station).to eq(exit_station)
    end

    it {is_expected.to respond_to(:complete_journey).with(1).argument}

    end

  describe 'calculate fare' do
    it {is_expected.to respond_to(:fare).with(0).argument}
  end

  describe 'journey completed' do
    let(:station) {double :station}
    it {is_expected.to respond_to(:complete_journey).with(1).argument}
    it 'false when class is brand new' do
      expect(journey.exit_station).to be_falsey
    end

end

end
