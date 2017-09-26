require 'spec_helper'

shared_examples_for 'a discount_strategy' do
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_presence_of :options }

  it { is_expected.to validate_uniqueness_of :code }
end
