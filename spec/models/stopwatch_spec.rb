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

  describe 'creation' do
    let(:stopwatch) { create(:stopwatch, started_at: nil, user: user) }

    it 'sets started_at and status to started by default' do
      expect(stopwatch).to have_attributes(started_at: be_within(1).of(Time.current),
                                           status: 'started')
    end
  end

  describe '#stop' do
    context 'when the running stopwatch is stopped' do
      let(:stopwatch) { build(:stopwatch, started_at: 5.minutes.ago, user: user) }

      it 'sets stopped_at to current time and updates status to stopped' do
        stopwatch.stop

        expect(stopwatch).to have_attributes(stopped_at: be_within(1).of(Time.current),
                                             status: 'stopped')
      end
    end

    context 'when stopping an already stopped stopwatch' do
      let(:stopwatch) { build(:stopwatch, :stopped, user: user) }

      it 'returns false' do
        expect(stopwatch.stop).to be false
      end
    end
  end

  describe '#elapsed_time_str' do
    context 'when started_at is nil' do
      let(:stopwatch) { build(:stopwatch, started_at: nil, user: user) }

      it 'returns zero' do
        expect(stopwatch.elapsed_time_str).to eq(t('time_tracker.elapsed', h: 0, m: 0, s: 0))
      end
    end

    context 'when the stopwatch is running' do
      let(:stopwatch) { build(:stopwatch, started_at: 5.minutes.ago, user: user) }

      it 'returns the elapsed time from the start until now' do
        expect(stopwatch.elapsed_time_str).to eq(t('time_tracker.elapsed', h: 0, m: 5, s: 0))
      end
    end

    context 'when the stopwatch is stopped' do
      let(:stopwatch) { build(:stopwatch, :stopped, user: user) }

      it 'returns the elapsed time from start to stop' do
        expect(stopwatch.elapsed_time_str).to eq(t('time_tracker.elapsed', h: 0, m: 5, s: 0))
      end
    end
  end

  describe '.stopped_recent' do
    let!(:started_stopwatch) { create(:stopwatch, user: user) }

    let!(:stopwatches) do
      4.downto(1).map do |i|
        create(:stopwatch, :stopped, stopped_at: i.minutes.from_now, user: user)
      end
    end

    context 'when there are multiple stopped and one started stopwatch' do
      it 'returns the 3 most recently stopped stopwatches in correct order' do
        expect(described_class.stopped_recent).to eq([stopwatches[3], stopwatches[2], stopwatches[1]])
      end

      it 'returns exactly 3 records by default' do
        expect(described_class.stopped_recent.count).to eq(3)
      end

      it 'does not return the first stopwatch of four' do
        expect(described_class.stopped_recent).not_to include(stopwatches[0])
      end

      it 'does not return the started stopwatch' do
        expect(described_class.stopped_recent).not_to include(started_stopwatch)
      end
    end
  end

  describe '#abort_if_user_has_active_stopwatch' do
    let(:new_started_stopwatch) { build(:stopwatch, user: user) }

    context 'when no active stopwatch exists' do
      it 'allows creation' do
        expect(new_started_stopwatch.save).to be_truthy
      end
    end

    context 'when user already has a running stopwatch' do
      before { create(:stopwatch, user: user) }

      it 'does not allow creation of a second stopwatch' do
        expect(new_started_stopwatch.save).to be_falsey
      end
    end

    context "when another user's stopwatch is running" do
      let(:other_user) { create(:user) }

      before { create(:stopwatch, user: other_user) }

      it 'allows you to create a stopwatch for the current user' do
        expect(new_started_stopwatch.save).to be_truthy
      end
    end
  end
end
