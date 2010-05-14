require "test_helper"
# not sure why this doesn't work..?
# require File.expand_path(File.dirname(__FILE__), File.join('..', 'lib', 'stanza', 'tercet'))
require File.expand_path(File.dirname(__FILE__) + "/../lib/stanza/tercet")


class TercetTest < Test::Unit::TestCase
  context "Tercet" do
    # maybe use Riot eventually?
    # http://github.com/thumblemonks/riot
    setup do
      @methods = %w[verse_send_connect_accept
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

    
    should 'define all Verse structs and unions' do
      @structs.each do |s|
        assert(Stanza::Tercet::Verse.const_defined?(s), "Stanza::Tercet::Verse should define struct/union #{s}")
      end
    end
    
    should 'define all Verse methods' do
      @methods.each do |s|
        assert(Stanza::Tercet::Verse.method_defined?(s), "Stanza::Tercet::Verse should define method #{s}")
      end
    end
    
    should 'define VERSION' do
      assert_match(/\A\d\.\d\z/, Stanza::Tercet.VERSION)
    end
    
  end
end
