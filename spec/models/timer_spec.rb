# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Timer do
  let_it_be(:user) { create(:user) }

  describe 'validations' do
    subject { build(:timer) }

    context 'when validating title' do
      it { is_expected.to validate_length_of(:title).is_at_most(10) }
    end

    context 'when validating duration_seconds' do
      it { is_expected.to validate_numericality_of(:duration_seconds) }
      it { is_expected.to validate_numericality_of(:duration_seconds).only_integer }
      it { is_expected.to validate_numericality_of(:duration_seconds).is_greater_than_or_equal_to(0) }
    end
  end

  describe 'creation' do
    let(:timer) { create(:timer, user: user) }

    it 'sets started_at and status to started by default' do
      expect(timer).to have_attributes(started_at: be_within(1).of(Time.current),
                                       status: 'started')
    end
  end

  describe '#stop' do
    context 'when stopping an expired timer' do
      let(:timer) { build(:timer, :expired, user: user) }

      it 'updates the status to stopped without changing duration_seconds and stopped_at' do
        timer.stop

        expect(timer).to have_attributes(duration_seconds: 60,
                                         stopped_at: be_within(1).of(1.hour.ago + 60),
                                         status: 'stopped')
      end
    end

    context 'when an unexpired timer is stopped' do
      let(:timer) { build(:timer, :unexpired, user: user) }

      it 'updates status and recalculates duration and stop time' do
        timer.stop

        expect(timer).to have_attributes(duration_seconds: be_within(1).of(5),
                                         stopped_at: be_within(1).of(Time.current),
                                         status: 'stopped')
      end
    end

    context 'when stopping an already stopped timer' do
      let(:timer) { build(:timer, :stopped, user: user) }

      it 'returns false' do
        expect(timer.stop).to be false
      end
    end
  end

  describe '#elapsed_time_str' do
    context 'when started_at is nil' do
      let(:timer) { build(:timer, user: user) }

      it 'returns zero' do
        expect(timer.elapsed_time_str).to eq(t('time_tracker.elapsed', h: 0, m: 0, s: 0))
      end
    end

    context 'when the timer is active and unexpired' do
      let(:timer) { build(:timer, :unexpired, user: user) }

      it 'returns the elapsed time from the start until now' do
        expect(timer.elapsed_time_str).to eq(t('time_tracker.elapsed', h: 0, m: 0, s: 5))
      end
    end

    context 'when the timer has expired' do
      let(:timer) { build(:timer, :expired, user: user) }

      it 'returns formatted duration_seconds' do
        expect(timer.elapsed_time_str).to eq(t('time_tracker.elapsed', h: 0, m: 1, s: 0))
      end
    end

    context 'when the timer is stopped' do
      let(:timer) { build(:timer, :stopped, user: user) }

      it 'returns formatted duration_seconds' do
        expect(timer.elapsed_time_str).to eq(t('time_tracker.elapsed', h: 0, m: 1, s: 0))
      end
    end
  end

  describe '.stopped_recent' do
    let!(:started_timer) { create(:timer, :unexpired, user: user) }

    let!(:timers) do
      4.downto(1).map do |i|
        duration = i * 10
        started_at = Time.current - duration.seconds
        create(
          :timer,
          :stopped,
          started_at: started_at,
          duration_seconds: duration,
          stopped_at: started_at + duration,
          user: user
        )
      end
    end

    context 'when there are multiple stopped and one started timer' do
      it 'returns the 3 most recently stopped timers in correct order' do
        expect(described_class.stopped_recent).to eq([timers[3], timers[2], timers[1]])
      end

      it 'returns exactly 3 records by default' do
        expect(described_class.stopped_recent.count).to eq(3)
      end

      it 'does not return the first timer of four' do
        expect(described_class.stopped_recent).not_to include(timers[0])
      end

      it 'does not return the started timer' do
        expect(described_class.stopped_recent).not_to include(started_timer)
      end
    end
  end
end
