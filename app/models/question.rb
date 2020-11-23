class Question < ApplicationRecord
    belongs_to :lesson
    has_many :answers, dependent: :destroy
    has_attached_file :image, styles: {display: "300x200#"},
        :storage => :s3,
        :s3_credentials => Proc.new{|a| a.instance.s3_credentials }
    validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
    validates :lesson_id, presence: true
    validates :content, presence: true, length: { maximum: 500 }
    

    def s3_credentials
     {:bucket => ENV["AWS_BUCKET"], :access_key_id => ENV["AWS_ACCESS_KEY"],
        :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"], :s3_region => ENV["AWS_SERVER"]}
    end
end
