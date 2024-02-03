require 'rails_helper'

RSpec.describe Cell, type: :model do
  it { should validate_presence_of :board }
  it { should validate_presence_of :alive }
  it { should validate_presence_of :x_position }
  it { should validate_presence_of :y_position }
end
