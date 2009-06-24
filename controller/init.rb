# Define a subclass of Ramaze::Controller holding your defaults for all
# controllers

class Controller < Ramaze::Controller
  layout('default'){|path, wish| !request.xhr?}
  helper :xhtml, :simple_captcha, :flash
  engine :Haml

  before_all { $title = "Justkez" }

end

# Here go your requires for subclasses of Controller:
require __DIR__('main')
