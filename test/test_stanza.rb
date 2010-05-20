require "test_helper"
# not sure why this doesn't work..?
# require File.expand_path(File.dirname(__FILE__), File.join('..', 'lib', 'stanza', 'tercet'))
require File.expand_path(File.dirname(__FILE__) + "/../lib/stanza")


class StanzaTest < Test::Unit::TestCase
  context "Stanza" do
    # maybe use Riot eventually?
    # http://github.com/thumblemonks/riot
    context 'Verse module' do
      setup do
        @functions = %w[
                      verse_set_port
                      verse_host_id_create
                      verse_host_id_set
                      verse_callback_set
                      verse_callback_update
                      verse_session_set
                      verse_session_get
                      verse_session_destroy
                      verse_session_get_size
                      verse_session_get_avatar
                      verse_session_get_time
                      verse_send_connect_accept
                      verse_send_node_create
                      verse_send_connect
                      verse_callback_update
                    ]
                  
        @structs = %w[VNodeType
                      VNodeOwner
                      VNOParamType
                      VNOParam
                      VNTagType
                      VNTagConstants
                      VNTag
                      VNSConnectConstants
                      VNRealFormat
                      VNQuat32
                      VNQuat64
                      VNOMethodConstants
                      VNGLayerType
                      VNMLightType
                      VNMNoiseType
                      VNMRampType
                      VNMRampChannel
                      VNMRampPoint
                      VNMBlendType
                      VNMFragmentType
                      VMatFrag
                      VNBLayerType
                      VNBTile
                      VNTConstants
                      VNAConstants
                      VNABlockType
                      VNABlock
                    ]
      end

      should 'something' do
      end

    end
    
  end
end
