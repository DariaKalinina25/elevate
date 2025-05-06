# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stopwatch do
  let_it_be(:user) { create(:user) }

  describe 'validations' do
    subject { build(:stopwatch) }

    context 'when validating title' do
      it { is_expected.to validate_length_of(:title).is_at_most(10) }
    end

    context 'when creating a stopwatch while another is running' do
      before { create(:stopwatch, user: user) }

      let(:new_started_stopwatch) { build(:stopwatch, user: user) }

      it 'is not valid' do
        expect(new_started_stopwatch).not_to be_valid
      end

      it 'adds base error' do
        new_started_stopwatch.valid?
        expect(new_started_stopwatch.errors[:base]).to include(I18n.t('time_tracker.errors.already_running'))
      end
    end

    context "when creating a stopwatch while another user's stopwatch is running" do
      before { create(:stopwatch, user: user) }

      let(:other_user) { create(:user) }
      let(:new_started_stopwatch) { build(:stopwatch, user: other_user) }

      it 'is valid' do
        expect(new_started_stopwatch).to be_valid
      end
    end
  end

  describe '#stop' do
    context 'when the stopwatch is started' do
      let(:stopwatch) { create(:stopwatch, user: user) }

      it 'sets started_at to creation time, has status started and stopped_at nil' do
        expect(stopwatch).to have_attributes(started_at: be_within(1).of(Time.current),
                                             stopped_at: nil,
                                             status: 'started')
      end
    end

    context 'when the running stopwatch is stopped' do
      let(:stopwatch) { build(:stopwatch, started_at: 5.minutes.ago, user: user) }

      it 'sets stopped_at to current time and updates status to stopped' do
        stopwatch.stop

        expect(stopwatch).to have_attributes(started_at: be_within(1).of(5.minutes.ago),
                                             stopped_at: be_within(1).of(Time.current),
                                             status: 'stopped')
      end
    end

    context 'when stopping an already stopped stopwatch' do
      let(:stopwatch) { create(:stopwatch, :stopped, stopped_at: 5.minutes.from_now, user: user) }

      it 'does nothing and returns false' do
        expect(stopwatch.stop).to be false
      end
    end
  end

  describe '#elapsed_time_str' do
    context 'when the stopwatch is running' do
      let(:stopwatch) { build(:stopwatch, started_at: 5.minutes.ago, user: user) }

      it 'returns the elapsed time from the start until now' do
        expect(stopwatch.elapsed_time_str).to eq('0h 5m 0s')
      end
    end

    context 'when the stopwatch is stopped' do
      let(:stopwatch) { create(:stopwatch, :stopped, stopped_at: 5.minutes.from_now, user: user) }

      it 'returns the elapsed time from start to stop' do
        expect(stopwatch.elapsed_time_str).to eq('0h 5m 0s')
      end
    end

    context 'when the stopwatch stops in milliseconds' do
      let(:stopwatch) { create(:stopwatch, :stopped, stopped_at: Time.current + 0.01, user: user) }

      it 'returns the elapsed time as zero' do
        expect(stopwatch.elapsed_time_str).to eq('0h 0m 0s')
      end
    end

    context 'when the stopwatch stops after more than 24 hours' do
      let(:stopwatch) { create(:stopwatch, :stopped, stopped_at: 2.days.from_now, user: user) }

      it 'returns the elapsed time in hours' do
        expect(stopwatch.elapsed_time_str).to eq('48h 0m 0s')
      end
    end
  end

  describe '.stopped_recent' do
    let!(:started_stopwatch) { create(:stopwatch, user: user) }
    let!(:stopwatch_first) { create(:stopwatch, :stopped, stopped_at: 4.minutes.from_now, user: user) }
    let!(:stopwatch_second) { create(:stopwatch, :stopped, stopped_at: 3.minutes.from_now, user: user) }
    let!(:stopwatch_third) { create(:stopwatch, :stopped, stopped_at: 2.minutes.from_now, user: user) }
    let!(:stopwatch_fourth) { create(:stopwatch, :stopped, stopped_at: 1.minute.from_now, user: user) }

    context 'when there are multiple stopped and one started stopwatch' do
      it 'returns the 3 most recently stopped stopwatches in correct order' do
        expect(described_class.stopped_recent).to eq([stopwatch_fourth, stopwatch_third, stopwatch_second])
      end

      it 'returns exactly 3 records by default' do
        expect(described_class.stopped_recent.count).to eq(3)
      end

      it 'does not return the first stopwatch of four' do
        expect(described_class.stopped_recent).not_to include(stopwatch_first)
      end

      it 'does not return the started stopwatch' do
        expect(described_class.stopped_recent).not_to include(started_stopwatch)
      end
    end
  end
end
