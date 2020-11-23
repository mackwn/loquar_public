class Lesson < ApplicationRecord
    has_many :questions, dependent: :destroy
    validates :name, presence: true
    #validates :content, presence: true
end
