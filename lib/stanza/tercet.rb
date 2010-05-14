require 'ffi'

module Stanza
  module Tercet
    
    # http://wiki.github.com/ffi/ffi/
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

      # V_REAL64_MAX = 1.7976931348623158e+308
      # V_REAL32_MAX = 3.402823466e+38f
      #define V_HOST_ID_SIZE	(3 * (512 / 8))		/* The size of host IDs (keys), in 8-bit bytes. */
      #VSession
      
      # typedef uint32    VNodeID;
      # typedef uint16    VLayerID;   /* Commonly used to identify layers, nodes that have them. */
      # typedef uint16    VBufferID;    /* Commonly used to identify buffers, nodes that have them. */
      # typedef uint16    VNMFragmentID;

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
               :vnode, :uint32, #VNodeID
               :vlayer, :uint16 #VLayerID
      end 
      VN_TAG_MAX_BLOB_SIZE = 500
      
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
      
      class Tanimation < FFI::Struct
        layout :curve, :uint32, #VNodeID
               :start, :uint32,
               :end,   :uint32
      end
      class Tblob < FFI::Struct
        layout :size, :uint16,
               :blob, :pointer
      end
      
      class VNTag < FFI::Union 
        layout :vboolean, :bool,
               :vuint32, :uint32,
               :vreal64, :double,
               :vstring, :pointer,
               :vreal64_vec3, [:double, 3],
               :vlink, :uint32, #VNodeID
               :vanimation, Tanimation,
               :vblob, Tblob
      end

      attach_function :verse_send_node_index_subscribe, [:uint32], :void
      attach_function :verse_send_connect, [:pointer, :pointer, :pointer, :pointer], :pointer # actually returns a VSession

      # extern void		verse_callback_update(uint32 microseconds);
      attach_function :verse_callback_update, [:uint32], :void
      # extern VSession verse_send_connect_accept(VNodeID avatar, const char *address, uint8 *host_id);
      attach_function :verse_send_connect_accept, [:uint32, :pointer, :uint8], :pointer
      # extern void verse_send_node_create(VNodeID node_id, VNodeType type, VNodeOwner owner);
      # FIXME: are the ints used just uint8s, or something else?
      attach_function :verse_send_node_create, [:uint32, :uint8, :uint8], :void
    end
    class Connection
      def self.new
        Verse.verse_send_connect
      end
    end
    
  end
end