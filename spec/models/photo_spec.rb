
describe Photo, :type => :model do
  it "has a valid factory" do
    expect(create(:photo)).to be_valid
  end

  it "is invalid without a filename" do
    expect(create(:photo)).to be_valid
  end


end
