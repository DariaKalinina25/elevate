# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DurationParser do
  describe '.to_seconds' do
    it 'returns 0 for blank string' do
      expect(described_class.to_seconds('')).to eq(0)
    end

    it 'returns 0 for nil' do
      expect(described_class.to_seconds(nil)).to eq(0)
    end

    it 'parses seconds only' do
      expect(described_class.to_seconds('00:00:30')).to eq(30)
    end

    it 'parses minutes and seconds' do
      expect(described_class.to_seconds('00:02:10')).to eq(130)
    end

    it 'parses hours, minutes, and seconds' do
      expect(described_class.to_seconds('01:01:01')).to eq(3661)
    end

    it 'handles leading zeros' do
      expect(described_class.to_seconds('00:00:01')).to eq(1)
    end
  end
end
