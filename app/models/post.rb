class Post < ActiveRecord::Base
  validates :title, :author_id, :sub_id, presence: true
  validates :author_id, uniqueness: { scope: [:sub_id, :title] }

  before_save :sanitize_links

  belongs_to(
    :author,
    class_name: 'User',
    foreign_key: :author_id,
    primary_key: :id
  )

  belongs_to(:sub)

  def sanitize_links
    unless self.url.blank?
      unless self.url.start_with?("http")
        self.url= "http\://" + self.url
      end
    end
  end
end
