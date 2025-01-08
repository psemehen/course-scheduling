class Teacher < ApplicationRecord
  include Personable

  has_many :sections, dependent: :destroy
  has_many :subjects, through: :sections
end
