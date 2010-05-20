require 'ffi'

module Stanza
  module Tercet
    
    module Verse

      extend FFI::Library
      
      # technique borrowed from rufus-tokyocabinet
      paths =
        Array(ENV['VERSE_LIB'] ||
        Dir['/{opt,usr}/{,local/}lib{,64}/libverse.{dylib,so*}'])

      begin

        ffi_lib(*paths)

      rescue LoadError => le
        raise(
          "couldn't find Verse lib. " +
          "Please install Verse (http://verse.blender.org/download/) "
        )
      end

      # Constants
      V_RELEASE_NUMBER = '6'
      V_RELEASE_PATCH = '1'
      V_RELEASE_LABEL = ''
      V_MAX_NAME_LENGTH_SHORT = 16
      V_MAX_NAME_LENGTH_LONG = 48
      V_MAX_NAME_PASS_LENGTH = 128
      # FIXME: what is Eskil calculating?
      # Hmm. This might be just for the C lib's use(albeit hacky), and not visible to anything else?
      # V_REAL64_MAX = 1.7976931348623158e+308
      # V_REAL32_MAX = 3.402823466e+38f
      #define V_HOST_ID_SIZE	(3 * (512 / 8))		/* The size of host IDs (keys), in 8-bit bytes. */
      VN_TAG_MAX_BLOB_SIZE = 500
      VN_B_TILE_SIZE = 8
      
      
      
      FFI.add_typedef(:uint32, :VNodeID)
      FFI.add_typedef(:uint16, :VLayerID) # verse.h: "Commonly used to identify layers, nodes that have them."
      FFI.add_typedef(:uint16, :VBufferID) # verse.h: "Commonly used to identify buffers, nodes that have them."
      FFI.add_typedef(:uint16, :VNMFragmentID)
      
      # VSession is defined in verse.h as typedef void *, which according to:
      # http://bytes.com/groups/c/567535-cast-function-pointer-void
      # is probably shorthand for a regular object pointer.
      FFI.add_typedef(:pointer, :VSession)

      VNodeType = enum(
        :V_NT_OBJECT, 0,
      	:V_NT_GEOMETRY,
      	:V_NT_MATERIAL,
      	:V_NT_BITMAP,
      	:V_NT_TEXT,
      	:V_NT_CURVE,
      	:V_NT_AUDIO,
      	:V_NT_NUM_TYPES,
      	# from original: V_NT_SYSTEM = V_NT_NUM_TYPES, 
        # so we assume they're meant to be the same, and start the count again.
      	:V_NT_SYSTEM, 7,
      	:V_NT_NUM_TYPES_NETPACK, 8
      )

      VNodeOwner = enum(
        :VN_OWNER_OTHER, 0,
      	:VN_OWNER_MINE
      )
      VNOParamType = enum(
        :VN_O_METHOD_PTYPE_INT8, 0,
      	:VN_O_METHOD_PTYPE_INT16,
      	:VN_O_METHOD_PTYPE_INT32,

      	:VN_O_METHOD_PTYPE_UINT8,
      	:VN_O_METHOD_PTYPE_UINT16,
      	:VN_O_METHOD_PTYPE_UINT32,

      	:VN_O_METHOD_PTYPE_REAL32,
      	:VN_O_METHOD_PTYPE_REAL64,

      	:VN_O_METHOD_PTYPE_REAL32_VEC2,
      	:VN_O_METHOD_PTYPE_REAL32_VEC3,
      	:VN_O_METHOD_PTYPE_REAL32_VEC4,

      	:VN_O_METHOD_PTYPE_REAL64_VEC2,
      	:VN_O_METHOD_PTYPE_REAL64_VEC3,
      	:VN_O_METHOD_PTYPE_REAL64_VEC4,

      	:VN_O_METHOD_PTYPE_REAL32_MAT4,
      	:VN_O_METHOD_PTYPE_REAL32_MAT9,
      	:VN_O_METHOD_PTYPE_REAL32_MAT16,

      	:VN_O_METHOD_PTYPE_REAL64_MAT4,
      	:VN_O_METHOD_PTYPE_REAL64_MAT9,
      	:VN_O_METHOD_PTYPE_REAL64_MAT16,

      	:VN_O_METHOD_PTYPE_STRING,

      	:VN_O_METHOD_PTYPE_NODE,
      	:VN_O_METHOD_PTYPE_LAYER
      )
      
      class VNOParam < FFI::Union 
        layout :vint8, :int8,  
               :vint16, :int16,
               :vint32, :int32,   
               :vuint8, :uint8,   
               :vuint16, :uint16,  
               :vuint32, :uint32,  
               :vreal32, :float,  
               :vreal64, :double, 
               :vreal32_vec, [:float, 4],  
               :vreal32_mat, [:float, 16],  
               :vreal64_vec, [:double, 4],  
               :vreal64_mat, [:double, 16], 
               :vstring, :pointer,    
               :vnode, :VNodeID,
               :vlayer, :VLayerID
      end 
      
      VNTagType = enum(
        :VN_TAG_BOOLEAN, 0,
        :VN_TAG_UINT32,
        :VN_TAG_REAL64,
        :VN_TAG_STRING,
        :VN_TAG_REAL64_VEC3,
        :VN_TAG_LINK,
        :VN_TAG_ANIMATION,
        :VN_TAG_BLOB,
        :VN_TAG_TYPE_COUNT
      )

      VNTagConstants = enum(
        :VN_TAG_GROUP_SIZE, 16,
        :VN_TAG_NAME_SIZE, 16,
        :VN_TAG_FULL_NAME_SIZE, 64,
        :VN_TAG_STRING_SIZE, 128
      )
      
      # TODO: any way to do nested structs so that we don't have to define these here?
      module NTag
        class Animation < FFI::Struct
          layout :curve, :VNodeID,
                 :start, :uint32,
                 :end,   :uint32
        end
        class Blob < FFI::Struct
          layout :size, :uint16,
                 :blob, :pointer
        end
      end
      
      class VNTag < FFI::Union 
        layout :vboolean, :bool,
               :vuint32, :uint32,
               :vreal64, :double,
               :vstring, :pointer,
               :vreal64_vec3, [:double, 3],
               :vlink, :VNodeID,
               :vanimation, NTag::Animation,
               :vblob, NTag::Blob
      end
      
      # FIXME: what is Eskil calculating?
      VNSConnectConstants = enum(
        :VN_S_CONNECT_NAME_SIZE, 32,
        :VN_S_CONNECT_KEY_SIZE, 4,
        :VN_S_CONNECT_DATA_SIZE, 32,
        :VS_S_CONNECT_HOSTID_PRIVATE_SIZE, 3 * 2048 / 8,
        :VS_S_CONNECT_HOSTID_PUBLIC_SIZE, 2 * 2048 / 8
      )
      
      VNRealFormat = enum(
      	:VN_FORMAT_REAL32,
      	:VN_FORMAT_REAL64
      )
      
      class VNQuat32 < FFI::Struct
        layout :x, :float,
               :y, :float,
               :z, :float,
               :w, :float
      end
      
      class VNQuat64 < FFI::Struct
        layout :x, :double,
               :y, :double,
               :z, :double,
               :w, :double
      end
      
      VNOMethodConstants = enum(
        :VN_O_METHOD_GROUP_NAME_SIZE, 16,
        :VN_O_METHOD_NAME_SIZE, 16,
        :VN_O_METHOD_SIG_SIZE, 256
      )
            
      FFI.add_typedef(:void, :VNOPackedParams) # verse.h: "Opaque type."
      
      # FIXME: look up what C says if the enum count starts over if you define one in the middle
      VNGLayerType = enum(
       :VN_G_LAYER_VERTEX_XYZ, 0,
       :VN_G_LAYER_VERTEX_UINT32,
       :VN_G_LAYER_VERTEX_REAL,
       :VN_G_LAYER_POLYGON_CORNER_UINT32, 128,
       :VN_G_LAYER_POLYGON_CORNER_REAL,
       :VN_G_LAYER_POLYGON_FACE_UINT8,
       :VN_G_LAYER_POLYGON_FACE_UINT32,
       :VN_G_LAYER_POLYGON_FACE_REAL
      )

      VNMLightType = enum(
       :VN_M_LIGHT_DIRECT, 0,
       :VN_M_LIGHT_AMBIENT,
       :VN_M_LIGHT_DIRECT_AND_AMBIENT,
       :VN_M_LIGHT_BACK_DIRECT,
       :VN_M_LIGHT_BACK_AMBIENT,
       :VN_M_LIGHT_BACK_DIRECT_AND_AMBIENT
      )

      VNMNoiseType = enum(
       :VN_M_NOISE_PERLIN_ZERO_TO_ONE, 0,
       :VN_M_NOISE_PERLIN_MINUS_ONE_TO_ONE,
       :VN_M_NOISE_POINT_ZERO_TO_ONE,
       :VN_M_NOISE_POINT_MINUS_ONE_TO_ONE
      )

      VNMRampType = enum(
       :VN_M_RAMP_SQUARE, 0,
       :VN_M_RAMP_LINEAR,
       :VN_M_RAMP_SMOOTH
      )

      VNMRampChannel = enum(
       :VN_M_RAMP_RED, 0,
       :VN_M_RAMP_GREEN,
       :VN_M_RAMP_BLUE
      )
      
      class VNMRampPoint < FFI::Struct
        layout :pos,   :double,
      	       :red,   :double,
      	       :green, :double,
      	       :blue,  :double
      	
      end
      
      VNMBlendType = enum(
       :VN_M_BLEND_FADE, 0,
       :VN_M_BLEND_ADD,
       :VN_M_BLEND_SUBTRACT,
       :VN_M_BLEND_MULTIPLY,
       :VN_M_BLEND_DIVIDE
      )

      VNMFragmentType = enum(
       :VN_M_FT_COLOR, 0,
       :VN_M_FT_LIGHT,
       :VN_M_FT_REFLECTION,
       :VN_M_FT_TRANSPARENCY,
       :VN_M_FT_VOLUME,
       :VN_M_FT_VIEW,
       :VN_M_FT_GEOMETRY,
       :VN_M_FT_TEXTURE,
       :VN_M_FT_NOISE,
       :VN_M_FT_BLENDER,
       :VN_M_FT_CLAMP,
       :VN_M_FT_MATRIX,
       :VN_M_FT_RAMP,
       :VN_M_FT_ANIMATION,
       :VN_M_FT_ALTERNATIVE,
       :VN_M_FT_OUTPUT
      )
      module MaterialFragment
        class Color < FFI::Struct
          layout :red,   :double,
                 :green, :double,
                 :blue,  :double
        end
        class Reflection < FFI::Struct
          layout :normal_falloff, :double
        end
        class Transparency < FFI::Struct
          layout :normal_falloff, :double,
                 :refraction_index, :double
        end
        class Volume < FFI::Struct
          layout :diffusion, :double,
                 :col_r, :double,
                 :col_g, :double,
                 :col_b, :double
          
        end
        class Geometry < FFI::Struct
          layout :layer_r, [:char, 16],
                 :layer_g, [:char, 16],
                 :layer_b, [:char, 16]
        end
        class Texture < FFI::Struct
          layout :bitmap, :VNodeID,
                 :layer_r, [:char, 16],
                 :layer_g, [:char, 16],
                 :layer_b, [:char, 16],
                 :filtered, :bool,
                 :mapping, :VNMFragmentID
        end
        class Noise < FFI::Struct
          layout :type, :uint8,
                 :mapping, :VNMFragmentID
        end
        class Blender < FFI::Struct
          layout :type, :uint8,
                 :data_a, :VNMFragmentID,
                 :data_b, :VNMFragmentID,
                 :control, :VNMFragmentID
        end
        class Clamp < FFI::Struct
          layout :min, :bool,
                 :red, :double,
                 :green, :double,
                 :blue, :double,
                 :data, :VNMFragmentID
        end
        class Matrix < FFI::Struct
          layout :matrix, [:double, 16],
                 :data, :VNMFragmentID
        end

        class Ramp < FFI::Struct
          layout :type, :uint8,
                 :channel, :uint8,
                 :mapping, :VNMFragmentID,
                 :point_count, :uint8,
                 :ramp, [VNMRampPoint, 48]
        end
        class Animation < FFI::Struct
          layout :label, [:char, 16]
        end
        class Alternative < FFI::Struct
          layout :alt_a, :VNMFragmentID,
                 :alt_b, :VNMFragmentID
        end
        class Output < FFI::Struct
          layout :label, [:char, 16],
                 :front, :VNMFragmentID,
                 :back, :VNMFragmentID
        end
      end

      class VMatFrag < FFI::Union 
        layout :color,        MaterialFragment::Color,
               :reflection,   MaterialFragment::Reflection,
               :transparency, MaterialFragment::Transparency,
               :volume,       MaterialFragment::Volume,
               :geometry,     MaterialFragment::Geometry,
               :texture,      MaterialFragment::Texture,
               :noise,        MaterialFragment::Noise,
               :blender,      MaterialFragment::Blender,
               :clamp,        MaterialFragment::Clamp,
               :matrix,       MaterialFragment::Matrix,
               :ramp,         MaterialFragment::Ramp,
               :animation,    MaterialFragment::Animation,
               :alternative,  MaterialFragment::Alternative,
               :output,       MaterialFragment::Output

      end
      VNBLayerType = enum(
      	:VN_B_LAYER_UINT1, 0,
      	:VN_B_LAYER_UINT8,
      	:VN_B_LAYER_UINT16,
      	:VN_B_LAYER_REAL32,
      	:VN_B_LAYER_REAL64
      )

      class VNBTile < FFI::Union 
        layout :vuint1, [:uint8, 8],
               :vuint8, [:uint8, 64],
            	 :vuint16, [:uint16, 64],
            	 :vreal32, [:float, 64],
            	 :vreal64, [:double, 64]
      end
      
      VNTConstants = enum(
      	:VN_T_CONTENT_LANGUAGE_SIZE, 32,
      	:VN_T_CONTENT_INFO_SIZE, 256,
      	:VN_T_BUFFER_NAME_SIZE, 16,
      	:VN_T_MAX_TEXT_CMD_SIZE, 1450
      )

      # verse.h: "This is how many *samples* are included in a block of the given type. Not bytes."
      VNAConstants = enum(
      	:VN_A_BLOCK_SIZE_INT8, 1024,
      	:VN_A_BLOCK_SIZE_INT16, 512,
      	:VN_A_BLOCK_SIZE_INT24, 384,
      	:VN_A_BLOCK_SIZE_INT32, 256,
      	:VN_A_BLOCK_SIZE_REAL32, 256,
      	:VN_A_BLOCK_SIZE_REAL64, 128
      )

      VNABlockType = enum(
      	:VN_A_BLOCK_INT8,
      	:VN_A_BLOCK_INT16,
      	:VN_A_BLOCK_INT24,
      	:VN_A_BLOCK_INT32,
      	:VN_A_BLOCK_REAL32,
      	:VN_A_BLOCK_REAL64
      )
      
      # verse.h: "Audio commands take pointers to blocks of these. They are not packed as unions."
      # FIXME: could have sworn I could use VNAConstants directly here
      class VNABlock < FFI::Union
      	layout :vint8, [:int8, 1024],
      	       :vint16,   [:int16, 512],
      	       :vint24,   [:int32, 384],
      	       :vint32,   [:int32, 256],
      	       :vreal32,  [:float, 256],
      	       :vreal64,  [:double,128]
      end
      
      # === Session / callback helper functions
      callback :generic_callback, [:pointer], :int 
      # extern void   verse_set_port(uint16 port);
      attach_function :verse_set_port, [:uint16], :void
      # extern void   verse_host_id_create(uint8 *id);
      attach_function :verse_host_id_create, [:uint8], :void
      # extern void   verse_host_id_set(uint8 *id);
      attach_function :verse_host_id_set, [:uint8], :void
      
      # FIXME: how should this map to Ruby? Sending Procs?
      # extern void   verse_callback_set(void *send_func, void *callback, void *user_data);
      attach_function :verse_callback_set, [:pointer, :generic_callback, :pointer], :void
      
      # extern void		verse_callback_update(uint32 microseconds);
      attach_function :verse_callback_update, [:uint32], :void
      
      # extern void   verse_session_set(VSession session);
      attach_function :verse_session_set, [:VSession], :void
      # extern VSession   verse_session_get(void);
      attach_function :verse_session_get, [:void], :VSession
      # extern void   verse_session_destroy(VSession session);
      attach_function :verse_session_destroy, [:VSession], :void
      # extern size_t verse_session_get_size(void);
      attach_function :verse_session_get_size, [:void], :size_t
      # extern VNodeID  verse_session_get_avatar(void);
      attach_function :verse_session_get_avatar, [:void], :VNodeID
      # extern void   verse_session_get_time(uint32 *seconds, uint32 *fractions);
      attach_function :verse_session_get_time, [:pointer, :pointer], :void
      
      # Not sure how to indicate that the buffers are meant for the enums, because they're pointers.
      # or is this setting what's in params, i.e. working on a chunk of memory?
      
      # extern VNOPackedParams * verse_method_call_pack(uint32 param_count, const VNOParamType *param_type, const VNOParam *params);
      attach_function :verse_method_call_pack, [:uint32, :buffer_in, :buffer_in],  :buffer_out
      # extern boolean  verse_method_call_unpack(const VNOPackedParams *data, uint32 param_count, const VNOParamType *param_type, VNOParam *params);
      attach_function :verse_method_call_unpack, [:buffer_in, :uint32, :buffer_in, :pointer], :bool
      

      
      
      
      
      # === Command sending functions
      
      # REMINDERS:
      # :buffer_in – Similar to :pointer, but optimized for Buffers that the function can only read (not write).
      # :buffer_out – Similar to :pointer, but optimized for Buffers that the function can only write (not read).
      # :buffer_inout – Similar to :pointer, but may be optimized for Buffers.
      # be wary of functions returning structs:
      # http://shrewdraven.org/content/passing-structs-value-ffi-rubyjruby
      # http://groups.google.com/group/ruby-ffi/browse_thread/thread/ace0b94f7912799f
      
      # extern VSession verse_send_connect(const char *name, const char *pass, const char *address, const uint8 *expected_host_id);
      # session = Stanza::Tercet::Verse.verse_send_connect("foo", "bar", "localhost", "3888")
      attach_function :verse_send_connect, [:buffer_in, :buffer_in, :buffer_in, :buffer_in], :VSession
      
      # extern void verse_send_node_index_subscribe(uint32 mask);
      attach_function :verse_send_node_index_subscribe, [:uint32], :void
      



      
      # extern VSession verse_send_connect_accept(VNodeID avatar, const char *address, uint8 *host_id);
      callback :verse_send_connect_accept, [:VNodeID, :buffer_in, :pointer], :VSession
      
      # extern void verse_send_node_create(VNodeID node_id, VNodeType type, VNodeOwner owner);
      # Stanza::Tercet::Verse.verse_send_node_create(1, :V_NT_OBJECT, :VN_OWNER_MINE)
      callback :verse_send_node_create, [:VNodeID, VNodeType, VNodeOwner], :void
    end
    
    def self.VERSION
      "#{Stanza::Tercet::Verse::V_RELEASE_NUMBER}.#{Stanza::Tercet::Verse::V_RELEASE_PATCH}"
    end
    
    class Connection
      def self.new
        Verse.verse_send_connect
      end
    end
    
  end
end
