require 'xmpp4r'
require 'xmpp4r/pubsub'
include Jabber

class ItSub < Sinatra::Base

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    Jabber::debug = true
  end

  configure do
    jid = JID::new('sub@guinevere.local/itps')
    password = 'subscriber'
    @@xmpp = Client.new(jid)
    @@xmpp.connect
    @@xmpp.auth(password)
    node = 'random/data'
    service = 'pubsub.guinevere.local'
    @@xmpp.send(Jabber::Presence.new.set_type(:available))
    sleep 1

    @@pubsub = PubSub::ServiceHelper.new(@@xmpp, service)
    @@pubsub.subscribe_to(node)
    subscriptions = @@pubsub.get_subscriptions_from_all_nodes()
    puts "subscriptions: #{subscriptions}\n\n"
    puts "events:\n"

    @@pubsub.add_event_callback do |event|
      begin
        event.payload.each do |e|
          puts e,"----\n"
        end
      rescue
        puts "Error : #{$!} \n #{event}"

      end
    end

    # infinite loop
    loop do
      sleep 1
    end
  end

  @@xmpp.close
end
