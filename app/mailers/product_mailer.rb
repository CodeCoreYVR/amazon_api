class ProductMailer < ApplicationMailer
  def notify_product_owner(product)
    @product = product
    @product_owner = product&.user
    mail to: @product_owner&.email, subject: 'You created a new product!'
  end

end
