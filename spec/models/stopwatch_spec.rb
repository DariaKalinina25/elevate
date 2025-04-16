# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stopwatch do
  let_it_be(:user) { create(:user) }

  describe 'validations' do
    subject { build(:stopwatch) }

    context 'when validating title' do
      it { is_expected.to validate_length_of(:title).is_at_most(10) }
    end
  end

  describe '#stop' do
    context 'when the stopwatch is started' do
      let(:stopwatch) { create(:stopwatch, user: user) }

      it 'sets started_at to creation time, has status started and stopped_at nil' do
        expect(stopwatch).to have_attributes(
          started_at: be_within(1).of(Time.current),
          stopped_at: nil,
          status: 'started'
        )
      end
    end

    context 'when the running stopwatch is stopped' do
      let(:stopwatch) { build(:stopwatch, user: user) }

      it 'sets stopped_at to current time and updates status to stopped' do
        stopwatch.stop

        expect(stopwatch).to have_attributes(
          stopped_at: be_within(1).of(Time.current),
          status: 'stopped'
        )
      end
    end

    context 'when stopping an already stopped stopwatch' do
      let(:stopwatch) { create(:stopwatch, :stopped, stopped_at: 5.minutes.from_now, user: user) }

      it 'does nothing and returns nil' do
        expect(stopwatch.stop).to be_nil
      end
    end
  end

  describe '#elapsed_time_str' do
    context 'when the stopwatch is running and elapsed time is requested' do
      let(:stopwatch) { build(:stopwatch, started_at: 5.minutes.ago, user: user) }

      it 'returns the elapsed time from the start until now' do
        expect(stopwatch.elapsed_time_str).to eq('0h 5m 0s')
      end
    end

    context 'when the stopwatch is stopped and the elapsed time is requested' do
      let(:stopwatch) { create(:stopwatch, :stopped, stopped_at: 5.minutes.from_now, user: user) }

      it 'returns the elapsed time from start to stop' do
        expect(stopwatch.elapsed_time_str).to eq('0h 5m 0s')
      end
    end

    context 'when the stopwatch is stopped in milliseconds and the elapsed time is requested' do
      let(:stopwatch) { create(:stopwatch, :stopped, stopped_at: Time.current + 0.01, user: user) }

      it 'returns the elapsed time as zero' do
        expect(stopwatch.elapsed_time_str).to eq('0h 0m 0s')
      end
    end
  end
end
