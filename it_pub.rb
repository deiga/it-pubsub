require 'xmpp4r'
require 'xmpp4r/pubsub'
require 'csv'
include Jabber

class ItPub

  def self.publish_data(pub_sub_service, data)
    item = Jabber::PubSub::Item.new
    xml = REXML::Element.new("data")
    xml.text = data

    item.add(xml);
    # publish item
    pub_sub_service.publish_item_to(@@node, item)
  end

  Jabber::debug = true

  service = 'pubsub.guinevere.local'
  jid = JID::new('pub@guinevere.local/itps')

  password = 'publisher'
  @@xmpp = Client.new(jid)
  @@xmpp.connect
  @@xmpp.auth(password)
  @@pubsub = PubSub::ServiceHelper.new(@@xmpp, service)
  @@node = 'random/data'
  begin
    @@pubsub.create_node('random')
    @@pubsub.create_node(@@node)
  rescue Jabber::ServerError => e
    puts "Error: #{e.error}"
    unless e.error.code == 409
      raise e
    end
  end

  @@time = 0
  CSV.foreach './data.csv' do |row|
    sleep row[0].to_i-@@time
    @@time = row[0].to_i
    publish_data @@pubsub,row[1]
  end

  @@xmpp.close
end
