module Enrollments
  class DownloadsController < ApplicationController
    def create
      send_data pdf,
        filename: "#{student.full_name} schedule.pdf",
        type: "application/pdf",
        disposition: "attachment"
    end

    private

    def student
      @student ||= Student.find(params[:student_id])
    end

    def enrollments
      @enrollments ||= student.enrollments.includes(:subject, section: [:teacher, :classroom])
    end

    def pdf
      WickedPdf.new.pdf_from_string(
        render_to_string(
          template: "enrollments/downloads/schedule",
          layout: "pdf",
          locals: {student: student, enrollments: enrollments}
        )
      )
    end
  end
end
