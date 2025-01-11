module Enrollments
  class DownloadsController < ApplicationController
    def create
      format = params[:format] || "pdf"
      result = Enrollments::ScheduleDownloadService.call(student, format)

      send_data result[:content],
        filename: result[:filename],
        type: result[:type],
        disposition: "attachment"
    rescue ArgumentError => e
      # log to sentry/other monitoring system, use I18n for translations
      Rails.logger.error "Invalid format requested: #{e.message}"
      flash[:error] = "Invalid format requested. Please try again."
      redirect_to student_enrollments_path(student)
    rescue => e
      # log to sentry/other monitoring system
      flash[:error] = "An error occurred while generating the schedule. Please try again."
      Rails.logger.error "An error occurred while generating the schedule: #{e.message}"
      redirect_to student_enrollments_path(student)
    end

    private

    def student
      @student ||= Student.find(params[:student_id])
    end
  end
end
