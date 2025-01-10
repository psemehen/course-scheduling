class EnrollmentsController < ApplicationController
  def index
    @enrollments = student.enrollments.includes(section: [:subject, :teacher])
    @available_sections = Section.includes(:subject, :teacher).where.not(id: student.section_ids)

    respond_to do |format|
      format.html
      format.json { render json: {enrollments: @enrollments, available_sections: @available_sections} }
    end
  end

  def create
    enrollment = student.enrollments.build(enrollment_params)

    respond_to do |format|
      if enrollment.save
        success_message = "Successfully enrolled in #{enrollment.subject.name} with #{enrollment.section.teacher.full_name}."
        format.html do
          flash[:success] = success_message
          redirect_to student_enrollments_path(student)
        end
        format.json { render json: {enrollment: enrollment, message: success_message}, status: :created }
      else
        error_messages = enrollment.errors.full_messages.join(", ")
        format.html do
          flash[:error] = "Failed to enroll in section: #{error_messages}"
          redirect_to student_enrollments_path(student)
        end
        format.json { render json: {errors: enrollment.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if enrollment.destroy
        success_message = "Successfully unenrolled from section."
        format.html do
          flash[:success] = success_message
          redirect_to student_enrollments_path(student)
        end
        format.json { render json: {message: success_message}, status: :ok }
      else
        error_message = "Failed to unenroll from section."
        format.html do
          flash[:error] = error_message
          redirect_to student_enrollments_path(student)
        end
        format.json { render json: {error: error_message}, status: :unprocessable_entity }
      end
    end
  end

  private

  def student
    @student ||= Student.find(params[:student_id])
  end

  def enrollment
    @enrollment ||= student.enrollments.find(params[:id])
  end

  def enrollment_params
    params.require(:enrollment).permit(:section_id, :subject_id)
  end
end
