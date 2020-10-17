class Stock < ApplicationRecord

  before_save {self.ticker = ticker.upcase }
  
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true, uniqueness:{ case_sensitive: false }

  def self.look_up(ticker_symbol)
    iex_key = Rails.application.credentials.iex_client[:sandbox_api_key]
    client = IEX::Api::Client.new(publishable_token: iex_key,
                                endpoint: 'https://sandbox.iexapis.com/v1')
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
    rescue => exception
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
    #Stock.where(ticker: ticker_symbol).first  This is same as above. We just didnt add Stock word because we are alreadyin Stock model and it is referenced automatically.
  end

end

