class User < ApplicationRecord
  has_one :token, dependent: :destroy
  before_save :downcase_attrs

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def to_h
    {
      id: id,
      name: name,
      email: email
    }
  end

  private

  def downcase_attrs
    self.email = email.strip.downcase
    self.name = name.strip.downcase
  end
end
