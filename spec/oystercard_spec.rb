require 'oystercard'

describe Oystercard do

  let(:station) {"Bank"}
  subject(:card1) { described_class.new }
  subject(:card2) { described_class.new }
  init_amount = 50

  before do
    card2.top_up(init_amount)
  end


  maximum_balance = Oystercard::MAX_BALANCE
  min_fare = Oystercard::MIN_FARE

  describe 'class exists' do
    it 'checks whether creates an instance of a class' do
      expect(card1).to be_a(Oystercard)
    end
    it 'has a balance of nil' do
      expect(card1.balance).to eq(0)
    end
  end

  describe 'accessing balance' do
    it {is_expected.to respond_to(:balance).with(0).argument}
    it 'creates an instance with balance' do
      expect(card2.balance).to eq(init_amount)
    end
  end

  describe 'top_up' do
    number = 10
    it "top_ups by £#{number}" do
      expect{ card1.top_up(number) }.to change{ card1.balance }.by number
    end
    it "stops user from having a balance beyond £#{maximum_balance}" do
      error_message = "Your card's balance cannot exceed £#{maximum_balance}."
      expect {card1.top_up(maximum_balance + 1)}.to raise_error (error_message)
    end
  end

  describe 'in_journey' do
    let(:station) {double :station}
    it 'checks that card is not in journey by default' do
      expect(card1.in_journey?).to be(false)
    end
    it 'reports if the card object is in journey' do
      card2.touch_in(station)
      expect(card2).to be_in_journey
    end
  end

  describe 'touch_in' do
    let(:station) {double :station}
    it 'sets value for variable in_journey to true' do
      card2.touch_in(station)
      expect(card2).to be_in_journey
    end
    it 'raises an error if card already checked in' do
      error_message = "You have already touched in!"
      card2.touch_in(station)
      expect {card2.touch_in(station)}.to raise_error(error_message)
    end
    it 'raised an error if card has insufficient funds' do
      error_message = "Insufficient funds for the journey."
      expect{card1.touch_in(station)}.to raise_error(error_message)
    end
    it { is_expected.to respond_to(:touch_in).with(1).argument }
    it "passes station to entry_station instance" do
      card2.touch_in(station)
      expect(card2.entry_station).to eq(station)
    end
  end

  describe 'touch_out' do
    let(:station) {double :station}
    it 'sets value for variable in_journey to false' do
      card2.touch_in(station)
      card2.touch_out(station)
      expect(card2).not_to be_in_journey
    end
    it "deducts the minimum fare of £#{min_fare} when touching out" do
      card2.touch_in(station)
      expect{ card2.touch_out(station) }.to change{ card2.balance }.by -min_fare
    end
    it 'raises an error if card already checked out' do
      error_message = "You have already touched out!"
      expect {card1.touch_out(station)}.to raise_error(error_message)
    end
    it 'sets entry station to nil' do
      card2.touch_in(station)
      card2.touch_out(station)
      expect(card2.entry_station).to eq nil
    end
  end

  describe 'history' do
    let(:station) {double :station}
    it 'history is empty by default' do
      expect(card2.history).to be_empty
    end
    it 'shows the one journey history of the card' do
      card2.touch_in(station)
      card2.touch_out(station)
      expect(card2.history).to eq ({"j1"=>[station, station]})
    end
    it 'shows the history of stations the card has been to, when more than 1' do
      n = 7
      hash = Hash.new
      n.times do
        card2.touch_in(station)
        card2.touch_out(station)
        hash.store("j#{hash.length + 1}",[station,station])

      end
      expect(card2.history).to eq (hash)
    end
  end
end
