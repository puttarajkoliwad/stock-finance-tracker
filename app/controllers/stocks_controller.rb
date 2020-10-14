class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.look_up(params[:stock])
      if @stock
        render 'users/my_portfolio'
      else
        flash[:alert] = "Please enter a valid ticker"
        redirect_to my_portfolio_path
      end
    else
      flash[:alert] = "Please enter a symbol to search!"
      redirect_to my_portfolio_path
    end
  end
end