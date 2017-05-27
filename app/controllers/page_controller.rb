class PageController < ApplicationController

  before_action :authenticate_user!, only: [ :law_firms, :bankers_contacts]

  def home_owners
  end

  def eligibility_sell
  end

  def eligibility_rent
  end

  def eligibility_buy
  end

  def eligibility_to_rent
  end

  def law_firms
  end

  def bankers_contacts
  end
end
