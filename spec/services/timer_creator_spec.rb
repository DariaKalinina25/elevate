# frozen_string_literal: true

# spec/services/timer_creator_spec.rb
require 'rails_helper'

RSpec.describe TimerCreator do
  let(:user) { create(:user) }

  def stopping_time(timer)
    timer.started_at + timer.duration_seconds
  end

  shared_examples 'successful save' do
    it 'saves a new timer' do
      expect(timer).to be_persisted
    end

    it 'creates a new timer with the calculated stopped_at' do
      expect(timer).to have_attributes(title: current_date_str,
                                       started_at: be_within(1).of(Time.current),
                                       duration_seconds: 1500,
                                       stopped_at: be_within(1).of(stopping_time(timer)),
                                       status: 'started')
    end
  end

  describe '#call' do
    context 'when there are no expired and active timers' do
      let!(:timer) { described_class.new(user: user, duration_seconds: 1500).call } # rubocop:disable RSpec/LetSetup

      it_behaves_like 'successful save'
    end

    context 'when there is an expired timer' do
      let!(:expired_timer) { create(:timer, :expired, title: 'expired', user: user) }
      let!(:timer) { described_class.new(user: user, duration_seconds: 1500).call } # rubocop:disable RSpec/LetSetup

      it 'changes the status of an expired timer to stopped' do
        expect(expired_timer.reload).to have_attributes(title: 'expired',
                                                        started_at: be_within(1).of(1.hour.ago),
                                                        duration_seconds: 60,
                                                        stopped_at: be_within(1).of(stopping_time(expired_timer)),
                                                        status: 'stopped')
      end

      it_behaves_like 'successful save'
    end

    context 'when there is an active unexpired timer' do
      let!(:active_unexpired) { create(:timer, :unexpired, title: 'unexpired', user: user) }
      let!(:timer) { described_class.new(user: user, duration_seconds: 1500).call }

      it 'does not change the active unexpired timer' do
        expect(active_unexpired.reload).to have_attributes(title: 'unexpired',
                                                           started_at: be_within(1).of(5.seconds.ago),
                                                           duration_seconds: 60,
                                                           stopped_at: be_within(1).of(stopping_time(active_unexpired)),
                                                           status: 'started')
      end

      it 'does not create a new timer' do
        expect(timer).to be_nil
      end
    end
  end
end
