class Post < ActiveRecord::Base
  validates :title, :author_id, :sub_id, presence: true
  validates :author_id, uniqueness: { scope: [:sub_id, :title] }

  belongs_to(
    :author,
    class_name: 'User',
    foreign_key: :author_id,
    primary_key: :id
  )

  belongs_to(:sub)
end
