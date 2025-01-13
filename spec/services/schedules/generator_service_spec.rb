require "rails_helper"

RSpec.describe Schedules::GeneratorService do
  let(:student) { create(:student) }
  let(:format) { "pdf" }
  let(:service) { described_class.new(student, format) }

  describe "#call" do
    context "when format is pdf" do
      let(:pdf_strategy) { instance_double(Schedules::PdfScheduleStrategy) }
      let(:pdf_result) { {content: "PDF content", filename: "schedule.pdf", type: "application/pdf"} }

      before do
        allow(Schedules::PdfScheduleStrategy).to receive(:new).with(student).and_return(pdf_strategy)
        allow(pdf_strategy).to receive(:call).and_return(pdf_result)
      end

      it "calls PdfScheduleStrategy" do
        expect(pdf_strategy).to receive(:call)
        service.call
      end

      it "returns the result from PdfScheduleStrategy" do
        expect(service.call).to eq(pdf_result)
      end
    end

    context "when format is invalid" do
      let(:format) { "invalid" }

      it "raises an ArgumentError" do
        expect { service.call }.to raise_error(ArgumentError, "Unsupported format: invalid")
      end
    end
  end
end
