class ShortenedUrl < ActiveRecord::Base
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true, uniqueness: true, length: {maximum: 255}
  validates :submitter_id, presence: true
  validate :no_spamming_allowed, on: :create

  belongs_to :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :url_id,
    primary_key: :id


  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :user

  has_many :taggings,
    class_name: "Tagging",
    foreign_key: :url_id,
    primary_key: :id

  has_many :tag_topics,
    through: :taggings,
    source: :tag_topic

  def self.random_code
    code = nil
    while code.nil? || self.exists?(:short_url => code)
      code = SecureRandom.urlsafe_base64
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(submitter_id: user.id, long_url: long_url, short_url: self.random_code)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visitors.where( { created_at: (Time.now - 10.minute)..Time.now}).count
  end

  def self.recently_submitted(submitter_id)
    all.where({ created_at: (Time.now - 1.minute)..Time.now, submitter_id: submitter_id})
  end

  private
  def no_spamming_allowed
    errors[:submitter_id] << "No Spamming!" if ShortenedUrl.recently_submitted(submitter_id).count > 5 
  end
end
