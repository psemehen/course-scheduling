require "rails_helper"

RSpec.describe "Schedules::Downloads", type: :request do
  let(:student) { create(:student) }
  let(:format) { "pdf" }
  let(:download_result) do
    {
      content: "PDF content",
      filename: "schedule.pdf",
      type: "application/pdf"
    }
  end

  describe "GET /schedules/:student_id/schedule/download" do
    context "when the download is successful" do
      before do
        allow(Schedules::GeneratorService).to receive(:call).and_return(download_result)
      end

      it "returns a successful response with the correct headers" do
        get download_student_schedule_path(student_id: student.id, format: format)

        expect(response).to have_http_status(:success)
        expect(response.headers["Content-Type"]).to eq("application/pdf")
        expect(response.headers["Content-Disposition"]).to include("attachment")
        expect(response.headers["Content-Disposition"]).to include("schedule.pdf")
        expect(response.body).to eq("PDF content")
      end

      it "caches the result" do
        expect(Rails.cache).to receive(:fetch).with(
          a_string_matching(/student_schedule\/#{student.id}/),
          expires_in: 1.hour
        ).and_yield

        get download_student_schedule_path(student_id: student.id, format: format)
      end
    end

    context "when an invalid format is requested" do
      it "redirects with an error message" do
        allow(Schedules::GeneratorService).to receive(:call).and_raise(ArgumentError)

        get download_student_schedule_path(student_id: student.id, format: "invalid")

        expect(response).to redirect_to(student_enrollments_path(student))
        follow_redirect!
        expect(response.body).to include("Invalid format requested. Please try again.")
      end
    end

    context "when a general error occurs" do
      it "redirects with an error message" do
        allow(Schedules::GeneratorService).to receive(:call).and_raise(StandardError)

        get download_student_schedule_path(student_id: student.id, format: format)

        expect(response).to redirect_to(student_enrollments_path(student))
        follow_redirect!
        expect(response.body).to include("An error occurred while generating the schedule. Please try again.")
      end
    end
  end
end
