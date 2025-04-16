# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stopwatch do
  describe '#stop' do
    let(:user) { create(:user) }

    context 'when the stopwatch is started' do
      let(:stopwatch) { create(:stopwatch, user: user) }
      
      it 'sets started_at to creation time, has status started and stopped_at nil' do
        expect(stopwatch).to have_attributes(
          started_at: be_within(1).of(Time.current),
          stopped_at: nil,
          status: "started"
        )
      end
    end

    context 'when the running stopwatch is stopped' do
      let(:stopwatch) { build(:stopwatch, user: user) }
      
      it 'sets stopped_at to current time and updates status to stopped' do
        stopwatch.stop

        expect(stopwatch).to have_attributes(
          stopped_at: be_within(1).of(Time.current),
          status: "stopped"
        )
      end
    end

    context 'when stopping an already stopped stopwatch' do
      let(:stopwatch) { create(:stopwatch, :stopped, user: user) }

      it 'does nothing and returns nil' do
        expect(stopwatch.stop).to eq(nil)
      end
    end
  end
end
