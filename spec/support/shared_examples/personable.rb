RSpec.shared_examples "personable model" do
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value("testuser@gmail.com").for(:email) }
  it { is_expected.not_to allow_value("invalid-email").for(:email) }

  describe "#full_name" do
    let(:user) { build(described_class.to_s.underscore.to_sym, first_name: "Test", last_name: "User") }

    it "returns the concatenated first and last name" do
      expect(user.full_name).to eq("Test User")
    end
  end
end