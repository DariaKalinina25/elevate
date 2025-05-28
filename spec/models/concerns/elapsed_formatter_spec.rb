# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ElapsedFormatter do
  let(:dummy_class) do
    Class.new do
      include ElapsedFormatter
      public :format_elapsed_time
    end.new
  end

  describe '#format_elapsed_time' do
    context 'when given 3723 seconds' do
      let(:result) { dummy_class.format_elapsed_time(3723) }

      it 'returns formatted time string' do
        expect(result).to eq('1h 2m 3s')
      end
    end
  end
end
