require "rails_helper"

RSpec.describe EnrollmentsController, type: :request do
  let(:student) { create(:student) }
  let(:section) { create(:section) }
  let(:subject) { create(:subject) }

  describe "POST /schedules/:student_id/enrollments" do
    let(:valid_attributes) { {enrollment: {section_id: section.id, subject_id: section.subject.id}} }

    context "with valid parameters" do
      it "creates a new Enrollment" do
        expect {
          post student_enrollments_path(student), params: valid_attributes
        }.to change(Enrollment, :count).by(1)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { {enrollment: {section_id: 999999, subject_id: 999999}} }

      it "does not create a new Enrollment" do
        expect {
          post student_enrollments_path(student), params: invalid_attributes
        }.not_to change(Enrollment, :count)
      end

      it "returns unprocessable entity status when requested JSON" do
        post student_enrollments_path(student), params: invalid_attributes, headers: {Accept: "application/json"}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /schedules/:student_id/enrollments/:id" do
    let!(:enrollment) { create(:enrollment, student: student) }

    it "destroys the requested enrollment" do
      expect {
        delete student_enrollment_path(student, enrollment)
      }.to change(Enrollment, :count).by(-1)
    end
  end
end
