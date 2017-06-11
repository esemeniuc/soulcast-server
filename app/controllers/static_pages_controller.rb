class StaticPagesController < ApplicationController
  def index
    @page_title = 'Soulcast | Send a message from your soul'
    @description = nil
  end

  def eula
    @page_title = 'Soulcast EULA'
    @description = nil
  end

  def proof
    @page_title = 'Soulcast | Kevin Zhang Proof'
    @description = nil
  end

end
