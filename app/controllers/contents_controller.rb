# -*- coding: utf-8 -*-
class ContentsController < ApplicationController
  def show
    if params[:id] && File.exist?(path = "#{Rails.root.to_s}/app/views/contents/#{params[:id]}.html.erb")
      case params[:id]
      when "index"
        @description = "" + @@description
        @keywords = @@keywords
        @title = @@title
      end
      render :file => path, :layout => true
    else
      render :text => "Page does not exists.", :status => 404
    end
  end
end
