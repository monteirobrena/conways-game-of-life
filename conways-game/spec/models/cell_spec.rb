require 'rails_helper'

RSpec.describe Cell, type: :model do
  it { should belong_to :board }
  it { should belong_to(:main_cell).optional(:false) }

  it { should have_many(:neighbors).class_name('Cell') }
  it { should have_many(:neighbors).with_foreign_key('id') }

  it { should validate_presence_of :board }
  it { should validate_presence_of :alive }
  it { should validate_presence_of :x_position }
  it { should validate_presence_of :y_position }
end
