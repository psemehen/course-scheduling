module Schedules
  class DownloadsController < ApplicationController
    def download
      format = params[:format] || "pdf"
      result = generate_schedule(format)
      send_schedule_file(result)
    rescue ArgumentError => e
      handle_invalid_format_error(e)
    rescue => e
      handle_general_error(e)
    end

    private

    def generate_schedule(format)
      Rails.cache.fetch(cache_key(format), expires_in: 1.hour) do
        Students::ScheduleDownloadService.call(student, format)
      end
    end

    def send_schedule_file(result)
      send_data result[:content],
        filename: result[:filename],
        type: result[:type],
        disposition: "attachment"
    end

    def handle_invalid_format_error(error)
      log_error("Invalid format requested", error)
      # Use I18n instead of hardcoded strings
      set_flash_error("Invalid format requested. Please try again.")
      redirect_to_enrollments_path
    end

    def handle_general_error(error)
      log_error("An error occurred while generating the schedule", error)
      set_flash_error("An error occurred while generating the schedule. Please try again.")
      redirect_to_enrollments_path
    end

    def log_error(message, error)
      # Log to Sentry or other monitoring system
      Rails.logger.error("#{message}: #{error.message}")
    end

    def set_flash_error(message)
      flash[:error] = message
    end

    def redirect_to_enrollments_path
      redirect_to student_enrollments_path(student)
    end

    def student
      @student ||= Student.find(params[:student_id])
    end

    def cache_key(format)
      enrollments_updated_at = student.enrollments.maximum(:updated_at).to_i
      "student_schedule/#{student.id}-#{student.updated_at.to_i}-#{enrollments_updated_at}-#{format}"
    end
  end
end
