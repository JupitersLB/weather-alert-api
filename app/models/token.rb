require 'securerandom'

class Token < ApplicationRecord
  belongs_to :user

  before_create :gen_tok

  def gen_tok
    self.value ||= SecureRandom.base58(36)
  end

  def to_h
    {
      id: id,
      label: label,
      scopes: scopes,
      value: self.value
    }
  end
end
