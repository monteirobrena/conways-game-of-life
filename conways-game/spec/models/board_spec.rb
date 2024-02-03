require 'rails_helper'

describe Board do
  it { should have_many :cells }

  it { should validate_presence_of :size }
  it { should validate_presence_of :attempts }
end