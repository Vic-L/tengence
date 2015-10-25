class PagesController < ActionController::Base
  layout :layout_for_page

  private
    def layout_for_page
      case params[:id]
      when 'lol'
      else
        'application'
      end
    end  
end
