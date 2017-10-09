require "rails_helper"

RSpec.describe Business, type: :model do
  it "is valid" do
    model = create(:business)
    expect(model).to be_valid
  end
end
