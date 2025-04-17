require 'rails_helper'

RSpec.describe SetTitleIfBlank do
  let(:dummy_class) do
    Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations
      include ActiveModel::Validations::Callbacks
      include SetTitleIfBlank

      attr_accessor :title
    end
  end

  subject { dummy_class.new(title: initial_title) }

  context 'when title is nil' do
    let(:initial_title) { nil }

    it 'sets the title to current date on validation' do
      subject.valid?
      expect(subject.title).to eq(current_date_str)
    end
  end

  context 'when title is blank' do
    let(:initial_title) { ' ' }

    it 'sets the title to current date on validation' do
      subject.valid?
      expect(subject.title).to eq(current_date_str)
    end
  end

  context 'when title is present' do
    let(:initial_title) { 'Some title' }

    it 'keeps the existing title' do
      subject.valid?
      expect(subject.title).to eq('Some title')
    end
  end
end
