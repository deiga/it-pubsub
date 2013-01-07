require 'xmpp4r'
require 'xmpp4r/pubsub'
include Jab

class ItSub < Sinatra::Base

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    Jabber::debug = true
  end
end
