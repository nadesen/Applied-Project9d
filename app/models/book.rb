class Book < ApplicationRecord
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags

  attr_accessor :tag_names
  after_save :save_tags

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  def self.search_for(content, method)
    if method == "perfect"
      Book.where(title: content)
    elsif method == "forward"
      Book.where("title LIKE ?", content + "%")
    elsif method == "backward"
      Book.where("title LIKE ?", "%" + content)
    else
      Book.where("title LIKE ?", "%" + content + "%")
    end
  end

  private

  def save_tags
    return unless tag_names

    self.tags = tag_names.split(',').map do |name|
      Tag.find_or_create_by(name: name.strip)
    end
  end

end
