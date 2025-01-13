require "rails_helper"

RSpec.describe Schedules::PdfScheduleStrategy do
  let(:student) { create(:student, first_name: "Paolo", last_name: "Sem") }
  let(:strategy) { described_class.new(student) }

  describe "#call" do
    before do
      allow(WickedPdf).to receive(:new).and_return(double(pdf_from_string: "PDF Content"))
    end

    it "returns a hash with the correct structure" do
      result = strategy.call

      expect(result).to be_a(Hash)
      expect(result[:content]).to eq("PDF Content")
      expect(result[:filename]).to eq("Paolo Sem schedule.pdf")
      expect(result[:type]).to eq("application/pdf")
    end
  end
end
