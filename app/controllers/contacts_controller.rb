class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    respond_to do |format|
    if @contact.deliver
      format.html { redirect_to @contact, notice: 'Повідомлення надіслано. Очікуйте відповідь.' }
    else
      flash.now[:error] = 'Не можливо надіслати повідомлення! Спробуйте ще раз!.'
      render :new
    end
    end
  end
end