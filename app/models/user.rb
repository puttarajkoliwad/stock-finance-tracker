class User < ApplicationRecord

  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol.upcase)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit?  && !stock_already_tracked?(ticker_symbol.upcase)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def self.search(param)
    param.strip!
    search_result = (match_first_name(param) + match_last_name(param) + match_email(param)).uniq
    return nil unless search_result
    search_result
  end

  def self.match_first_name(param)
    matches("first_name", param)
  end

  def self.match_last_name(param)
    matches("last_name", param)
  end

  def self.match_email(param)
    matches("email", param)
  end
  
  def self.matches(field, param)
    where("#{field} like ?", "%#{param}%")
  end

  def exclude_self(users)
    users.reject { |user| user.id == self.id }
  end

  def is_a_friend?(user_id)
    friends.where(id: user_id).exists?
  end

end
