class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery prepend: true


  Hash.class_eval do
    # Overrides "method_missing" to return the value of key of a hash
    # E.g, {a: "test"}.a will return "test"
    def method_missing(m, *args, &blk)
      (fetch(m) { fetch(m.to_s) { super } }) rescue nil
    end
  end
end
