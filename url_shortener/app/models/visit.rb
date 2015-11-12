class Visit < ActiveRecord::Base
  validates :user_id, :url_id, presence: true

  belongs_to :shortened_url,
    class_name: "ShortenedUrl",
    primary_key: :id,
    foreign_key: :url_id

  belongs_to :user,
    class_name: "User",
    primary_key: :id,
    foreign_key: :user_id

  def self.record_visit!(user, shortened_url)
    self.create!(user_id: user.id, url_id: shortened_url.id)
  end

end
