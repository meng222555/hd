require 'rails_helper'

RSpec.describe Bathroom, type: :model do
  it "has pre-loaded records" do
    expect(Bathroom.count).to be > 0
  end
end
