module Students
  class PdfScheduleStrategy < BaseService
    def initialize(student)
      @student = student
    end

    def call
      {
        content: pdf_content,
        filename: "#{student.full_name} schedule.pdf",
        type: "application/pdf"
      }
    end

    private

    attr_reader :student

    def pdf_content
      WickedPdf.new.pdf_from_string(
        ApplicationController.render(
          template: "students/schedule_downloads/show",
          layout: "pdf",
          locals: {student: student, enrollments: enrollments}
        )
      )
    end

    def enrollments
      student.enrollments.includes(:subject, section: [:teacher, :classroom])
    end
  end
end
