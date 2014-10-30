# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  before_filter :prepare_meta

  protect_from_forgery
  @@title = "Travis Bickle (トラヴィス ビックル)"
  @@description = ""
  @@keywords = ""

  def prepare_meta
    @title = @@title
    @description = @@description
    @keywords = @@keywords
  end

  def after_sign_in_path_for(resource)
    "#{reports_path}/#{Date.today.year}/#{Date.today.month}/#{Date.today.day}"
  end
end
