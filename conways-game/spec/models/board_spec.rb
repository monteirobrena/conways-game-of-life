require 'rails_helper'

describe Board do
    it { should validate_presence_of :size }
end