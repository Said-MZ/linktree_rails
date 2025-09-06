class Tree < ApplicationRecord
  paginates_per 12
  extend FriendlyId
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :style, presence: true, inclusion: { in: %w[Classic Modern Minimal] }
  validate :at_least_one_social_media

  validates :youtube, format: { with: /\Ahttps?:\/\/(www\.)?youtube\.com\/.+\z/, message: "must be a valid YouTube URL" }, allow_blank: true
  validates :instagram, format: { with: /\Ahttps?:\/\/(www\.)?instagram\.com\/.+\z/, message: "must be a valid Instagram URL" }, allow_blank: true
  validates :x, format: { with: /\Ahttps?:\/\/(www\.)?x\.com\/.+\z/, message: "must be a valid X (Twitter) URL" }, allow_blank: true

  friendly_id :name, use: :slugged

  belongs_to :user

  before_save :clean_social_links

  scope :by_user, ->(user) { where(user: user) }
  scope :by_style, ->(style) { where(style: style) }
  scope :recent, -> { order(created_at: :desc) }

  def should_generate_new_friendly_id?
    name_changed? || slug.blank?
  end

  def social_links
    [x, youtube, instagram].compact_blank
  end

  def display_name
    name.titleize
  end

  private

  def at_least_one_social_media
    if social_links.empty?
      errors.add(:base, "At least one social media link must be present")
    end
  end

  def clean_social_links
    %i[x youtube instagram].each do |attr|
      link = send(attr)
      next if link.nil?

      last_slash = link.rindex('/')
      after_last_slash = last_slash ? link[(last_slash + 1)..] : ""
      send("#{attr}=", nil) if after_last_slash.blank?
    end
  end
end
