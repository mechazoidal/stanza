# OLD attempt at making FFI interface. Salvage what we can, then delete.

# from: http://blog.headius.com/2008/10/ffi-for-ruby-now-available.html
# class Passwd < FFI::Struct
#   layout :pw_name, :string, 0,
#          :pw_passwd, :string, 4,
#          :pw_uid, :uint, 8,
#          :pw_gid, :uint, 12,
#          :pw_dir, :string, 20,
#          :pw_shell, :string, 24
# end

# extend FFI::Library


# Docs: http://kenai.com/projects/ruby-ffi/pages/Home
# Another xample: http://www.automatthew.com/2008/11/ruby-ffi-example-with-libmdb.html

# typedef uint32    VNodeID;
# typedef uint16    VLayerID;   /* Commonly used to identify layers, nodes that have them. */
# typedef uint16    VBufferID;    /* Commonly used to identify buffers, nodes that have them. */
# typedef uint16    VNMFragmentID;

# VSession
# TODO: see if a VSession can be a struct, because typedef'ing a void pointer makes me hella nervous.
# NOTE: this isn't "bad", but kinda odd: http://bytes.com/groups/c/567535-cast-function-pointer-void

# functions:
# verse_send_node_index_subscribe(mask)
# verse_callback_set()
# verse_send_connect
# verse_callback_update
# verse_send_connect_accept
# verse_send_node_create

module Verse
  
  extend FFI::Library
  ffi_lib "verse"
  
  class VNodeType
    V_NT_OBJECT = 0
  	V_NT_GEOMETRY = 1
  	V_NT_MATERIAL = 2
  	V_NT_BITMAP = 3
  	V_NT_TEXT = 4
  	V_NT_CURVE = 5
  	V_NT_AUDIO = 6
  	V_NT_NUM_TYPES = 7
  	# original: V_NT_SYSTEM = V_NT_NUM_TYPES, 
    # so we assume they're meant to be the same, and start the count again.
  	V_NT_SYSTEM = 7
  	V_NT_NUM_TYPES_NETPACK = 8
  end
  
  class VNodeOwner
    VN_OWNER_OTHER = 0
  	VN_OWNER_MINE = 1
  end
  
  class VNOParamType
    VN_O_METHOD_PTYPE_INT8 = 0
  	VN_O_METHOD_PTYPE_INT16 = 1
  	VN_O_METHOD_PTYPE_INT32 = 2

  	VN_O_METHOD_PTYPE_UINT8 = 3
  	VN_O_METHOD_PTYPE_UINT16 = 4
  	VN_O_METHOD_PTYPE_UINT32 = 5

  	VN_O_METHOD_PTYPE_REAL32 = 6
  	VN_O_METHOD_PTYPE_REAL64 = 7

  	VN_O_METHOD_PTYPE_REAL32_VEC2 = 8
  	VN_O_METHOD_PTYPE_REAL32_VEC3 = 9
  	VN_O_METHOD_PTYPE_REAL32_VEC4 = 10

  	VN_O_METHOD_PTYPE_REAL64_VEC2 = 11
  	VN_O_METHOD_PTYPE_REAL64_VEC3 = 12
  	VN_O_METHOD_PTYPE_REAL64_VEC4 = 13

  	VN_O_METHOD_PTYPE_REAL32_MAT4 = 14
  	VN_O_METHOD_PTYPE_REAL32_MAT9 = 15
  	VN_O_METHOD_PTYPE_REAL32_MAT16 = 16

  	VN_O_METHOD_PTYPE_REAL64_MAT4 = 17
  	VN_O_METHOD_PTYPE_REAL64_MAT9 = 18
  	VN_O_METHOD_PTYPE_REAL64_MAT16 = 19

  	VN_O_METHOD_PTYPE_STRING = 20

  	VN_O_METHOD_PTYPE_NODE = 21
  	VN_O_METHOD_PTYPE_LAYER = 22
  end
  
  V_RELEASE_NUMBER = 6
  V_RELEASE_PATCH = 1
  V_RELEASE_LABEL = ""

  # TODO: specify these in Ruby math  
  # V_REAL64_MAX = 1.7976931348623158e+308
  # V_REAL32_MAX = 3.402823466e+38f
  
  # TODO: check that ruby math won't screw this up
  V_HOST_ID_SIZE = (3 * (512 / 8))		# "The size of host IDs (keys), in 8-bit bytes."
  
  # extern void verse_send_node_index_subscribe(uint32 mask);
  attach_function :verse_send_node_index_subscribe, [:uint32], :void
  
  
  # extern VSession verse_send_connect(const char *name, const char *pass, const char *address, const uint8 *expected_host_id);
  attach_function :verse_send_connect, [:pointer, :pointer, :pointer, :pointer], :pointer # actually returns a VSession
  
  # extern void		verse_callback_set(void *send_func, void *callback, void *user_data);
  # callback :user_callback, [:pointer(user_data)], :void
  # attach_function :send_func, [:types, :user_callback], :void
  # callback :qsort_cmp, [ :pointer, :pointer ], :int
  # attach_function :qsort, [ :pointer, :int, :int, :qsort_cmp ], :int
  
  # static void callback_connect_accept(void *user, uint32 avatar, void *address, void *connection, const uint8 *host_id)

  
  # extern void		verse_callback_update(uint32 microseconds);
  attach_function :verse_callback_update, [:uint32], :void
  # extern VSession verse_send_connect_accept(VNodeID avatar, const char *address, uint8 *host_id);
  attach_function :verse_send_connect_accept, [:uint32, :pointer, :uint8], :pointer
  # extern void verse_send_node_create(VNodeID node_id, VNodeType type, VNodeOwner owner);
  # FIXME: are the ints used just uint8s, or something else?
  attach_function :verse_send_node_create, [:uint32, :uint8, :uint8], :void
  
end
