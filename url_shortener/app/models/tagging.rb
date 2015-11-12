class Tagging < ActiveRecord::Base
  validates :tag_topic_id, presence: true
  validates :url_id, presence: true

  belongs_to :tag_topic,
    class_name: "TagTopic",
    primary_key: :id,
    foreign_key: :tag_topic_id

  belongs_to :url,
    class_name: "ShortenedUrl",
    primary_key: :id,
    foreign_key: :url_id

end
