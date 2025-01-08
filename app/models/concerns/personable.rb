module Personable
  extend ActiveSupport::Concern

  included do
    validates :first_name, :last_name, :email, presence: true
    validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, uniqueness: {case_sensitive: false}
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
