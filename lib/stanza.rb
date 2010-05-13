module Stanza
  # http://wiki.github.com/ffi/ffi/
  
  # class Stanza
  #   VERSION = '1.0.0'
  # end
  extend FFI::Library
  ffi_lib "verse"
  
  #define V_REAL64_MAX         1.7976931348623158e+308
  #define V_REAL32_MAX         3.402823466e+38f
  
  #VSession
  
  VNodeType = enum(
    :V_NT_OBJECT, 0,
  	:V_NT_GEOMETRY,
  	:V_NT_MATERIAL,
  	:V_NT_BITMAP,
  	:V_NT_TEXT,
  	:V_NT_CURVE,
  	:V_NT_AUDIO,
  	:V_NT_NUM_TYPES,
  	# original: V_NT_SYSTEM = V_NT_NUM_TYPES, 
    # so we assume they're meant to be the same, and start the count again.
    # FIXME: doesn't seem like it should be right?
  	:V_NT_SYSTEM, 7
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