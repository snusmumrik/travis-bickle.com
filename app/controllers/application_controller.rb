# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  @@description = ""
  @@keywords = ""
  @@title = ""
  # development
  @@app_key = "MtvuO1goNecBIZk0xpP6FLZaZeTwUUQJ"
  # production
  # @@app_key = "CSNZp9p4iZRVxFklhloFxFEeKMRUrGZV"
end
