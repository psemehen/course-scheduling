class SchedulesController < ApplicationController
  def show
    @enrollments = student.enrollments.includes(:subject, section: [:teacher, :classroom])
    @available_sections = Section.includes(:subject, :teacher, :classroom).where.not(id: student.section_ids)

    respond_to do |format|
      format.html
      format.json { render json: {enrollments: @enrollments, available_sections: @available_sections} }
    end
  end

  private

  def student
    @student ||= Student.find(params[:student_id])
  end
end
