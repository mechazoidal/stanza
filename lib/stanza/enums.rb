module Stanza
  module Verse
      class VNodeType
        V_NT_OBJECT = 0
      	V_NT_GEOMETRY = 1
      	V_NT_MATERIAL = 2
      	V_NT_BITMAP = 3
      	V_NT_TEXT = 4
      	V_NT_CURVE = 5
      	V_NT_AUDIO = 6
      	V_NT_NUM_TYPES = 7
      	# from original: V_NT_SYSTEM = V_NT_NUM_TYPES
        # so we assume they're meant to be the same = and start the count again.
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


      class VNTagType
        VN_TAG_BOOLEAN = 0
        VN_TAG_UINT32 = 1
        VN_TAG_REAL64 = 2
        VN_TAG_STRING = 3
        VN_TAG_REAL64_VEC3 = 4
        VN_TAG_LINK = 5
        VN_TAG_ANIMATION = 6
        VN_TAG_BLOB = 7
        VN_TAG_TYPE_COUNT = 8
      end

      class VNTagConstants
        VN_TAG_GROUP_SIZE = 16
        VN_TAG_NAME_SIZE = 16
        VN_TAG_FULL_NAME_SIZE = 64
        VN_TAG_STRING_SIZE = 128
      end

      # FIXME: what is Eskil calculating?
      class VNSConnectConstants
        VN_S_CONNECT_NAME_SIZE = 32
        VN_S_CONNECT_KEY_SIZE = 4
        VN_S_CONNECT_DATA_SIZE = 32
        VS_S_CONNECT_HOSTID_PRIVATE_SIZE = 3 * 2048 / 8
        VS_S_CONNECT_HOSTID_PUBLIC_SIZE = 2 * 2048 / 8
      end
      
      class VNRealFormat
      	VN_FORMAT_REAL32 = 0
      	VN_FORMAT_REAL64 = 1
      end

      class VNOMethodConstants
        VN_O_METHOD_GROUP_NAME_SIZE = 16
        VN_O_METHOD_NAME_SIZE = 16
        VN_O_METHOD_SIG_SIZE = 256
      end

      class VNGLayerType
       VN_G_LAYER_VERTEX_XYZ = 0
       VN_G_LAYER_VERTEX_UINT32 = 1
       VN_G_LAYER_VERTEX_REAL = 2
       VN_G_LAYER_POLYGON_CORNER_UINT32 = 128
       VN_G_LAYER_POLYGON_CORNER_REAL = 129
       VN_G_LAYER_POLYGON_FACE_UINT8 = 130
       VN_G_LAYER_POLYGON_FACE_UINT32 = 131
       VN_G_LAYER_POLYGON_FACE_REAL = 132
      end

      class VNMLightType
       VN_M_LIGHT_DIRECT = 0
       VN_M_LIGHT_AMBIENT = 1
       VN_M_LIGHT_DIRECT_AND_AMBIENT = 2
       VN_M_LIGHT_BACK_DIRECT = 3
       VN_M_LIGHT_BACK_AMBIENT = 4
       VN_M_LIGHT_BACK_DIRECT_AND_AMBIENT = 5
      end

      class VNMNoiseType
       VN_M_NOISE_PERLIN_ZERO_TO_ONE = 0
       VN_M_NOISE_PERLIN_MINUS_ONE_TO_ONE = 1
       VN_M_NOISE_POINT_ZERO_TO_ONE = 2
       VN_M_NOISE_POINT_MINUS_ONE_TO_ONE = 3
      end

      class VNMRampType
       VN_M_RAMP_SQUARE = 0
       VN_M_RAMP_LINEAR = 1
       VN_M_RAMP_SMOOTH = 2
      end

      class VNMRampChannel
       VN_M_RAMP_RED = 0
       VN_M_RAMP_GREEN = 1
       VN_M_RAMP_BLUE = 2
      end

      class VNMBlendType
       VN_M_BLEND_FADE = 0
       VN_M_BLEND_ADD = 1
       VN_M_BLEND_SUBTRACT = 2
       VN_M_BLEND_MULTIPLY = 3
       VN_M_BLEND_DIVIDE = 4
      end

      class VNMFragmentType
       VN_M_FT_COLOR = 0
       VN_M_FT_LIGHT = 1
       VN_M_FT_REFLECTION = 2
       VN_M_FT_TRANSPARENCY = 3
       VN_M_FT_VOLUME = 4
       VN_M_FT_VIEW = 5
       VN_M_FT_GEOMETRY = 6
       VN_M_FT_TEXTURE = 7
       VN_M_FT_NOISE = 8
       VN_M_FT_BLENDER = 9
       VN_M_FT_CLAMP = 10
       VN_M_FT_MATRIX = 11
       VN_M_FT_RAMP = 12
       VN_M_FT_ANIMATION = 13
       VN_M_FT_ALTERNATIVE = 14
       VN_M_FT_OUTPUT = 15
      end

      class VNBLayerType
      	VN_B_LAYER_UINT1 = 0
      	VN_B_LAYER_UINT8 = 1
      	VN_B_LAYER_UINT16 = 2
      	VN_B_LAYER_REAL32 = 3
      	VN_B_LAYER_REAL64 = 4
      end

      class VNTConstants
      	N_T_CONTENT_LANGUAGE_SIZE = 32
      	VN_T_CONTENT_INFO_SIZE = 256
      	VN_T_BUFFER_NAME_SIZE = 16
      	VN_T_MAX_TEXT_CMD_SIZE = 1450
      end

      # verse.h: "This is how many *samples* are included in a block of the given type. Not bytes."
      class VNAConstants
      	VN_A_BLOCK_SIZE_INT8 = 1024
      	VN_A_BLOCK_SIZE_INT16 = 512
      	VN_A_BLOCK_SIZE_INT24 = 384
      	VN_A_BLOCK_SIZE_INT32 = 256
      	VN_A_BLOCK_SIZE_REAL32 = 256
      	VN_A_BLOCK_SIZE_REAL64 = 128
      end

      class VNABlockType
      	VN_A_BLOCK_INT8 = 0
      	VN_A_BLOCK_INT16 = 1
      	VN_A_BLOCK_INT24 = 2
      	VN_A_BLOCK_INT32 = 3
      	VN_A_BLOCK_REAL32 = 4
      	VN_A_BLOCK_REAL64 = 5
      end

  end
end
