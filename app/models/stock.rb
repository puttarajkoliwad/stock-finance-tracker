class Stock < ApplicationRecord

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


  private

  
  
end
