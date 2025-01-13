module Schedules
  class GeneratorService < BaseService
    def initialize(student, format)
      @student = student
      @format = format
    end

    def call
      strategy.call
    end

    private

    attr_reader :student, :format

    def strategy
      case format.to_sym
      when :pdf
        PdfScheduleStrategy.new(student)
      else
        raise ArgumentError, "Unsupported format: #{format}"
      end
    end
  end
end
