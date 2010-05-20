module Stanza
   module Verse
      require 'bindata'
      # effectively these are just typedefs
      class Boolean << BinData::Primitive
	uint8 :data
	def get; self.data; end
	def set(v); self.data = v; end
      end
      class VNodeID << BinData::Primitive
	uint32 :data
	def get; self.data; end
	def set(v); self.data = v; end
      end
      class VLayerID << BinData::Primitive
	uint16 :data
	def get; self.data; end
	def set(v); self.data = v; end
      end
      class VNMFragmentID << BinData::Primitive
	uint16 :data
	def get; self.data; end
	def set(v); self.data = v; end
      end
      class VBufferID << BinData::Primitive
	uint16 :data
	def get; self.data; end
	def set(v); self.data = v; end
      end

      class Blob << BinData::Primitive
        uint16 :size, :value => lambda {blob.length}
        array :blob, :read_length => :size
        def get; self.data; end
        def set(v); self.data = v; end
      end
      class VNMRampPoint << BinData::Record
        double :pos
        double :red
	double :green
	double :blue
      end 
      class Animation < BinData::Record
        VNodeID :curve
        uint32 :start 
        uint32 :end 
      end
      
      # Verse only uses 2 8-byte fixed-length string types.
      class String16 << BinData::Wrapper
	string :length => 16
      end
      class String500 << BinData::Wrapper
	string :length => 500
      end

      class VNOParam < BinData::Record 
        int8 :vint8  
        int16 :vint16
        int32 :vint32   
        uint8 :vuint8   
        uint16 :vuint16  
        uint32 :vuint32  
        float :vreal32  
        double :vreal64 
        array :vreal32_vec, :type=>:float, :initial_length=>4
        uint8 :vreal32_mat, :type=>:float, :initial_length=>16
        uint8 :vreal64_vec, :type=>:double, :initial_length=>4
        uint8 :vreal64_mat, :type=>:double, :initial_length=>16
        string500 :vstring    
        v_node_id :vnode
        v_layer_id :vlayer
      end 

      class VNTag < BinData::Record 
        boolean :vboolean, :bool,
        uint32 :vuint32, :uint32,
        double :vreal64, :double,
        string500 :vstring, :pointer,
        array :vreal64_vec3, [:double, 3],
        v_node_id :vlink, :VNodeID,
        animation :vanimation
        blob :vblob
      end
      module MaterialFragment
        class Color < BinData::Record
          double :red
          double :green
          double :blue
        end
        class Reflection < BinData::Record
          double :normal_falloff
        end
        class Transparency < BinData::Record
          double :normal_falloff, :double,
          double :refraction_index, :double
        end
        class Volume < BinData::Record
          double :diffusion
          double :col_r
          double :col_g
          double :col_b
          
        end
        class Geometry < BinData::Record
          array :layer_r, :type>:char, :initial_size=>16
          array :layer_g, :type>:char, :initial_size=>16
          array :layer_b, :type>:char, :initial_size=>16
        end
        class Texture < BinData::Record
          v_node_id :bitmap, :VNodeID,
          array :layer_r, :type=>:char, :initial_size=>16
          array :layer_g, :type=>:char, :initial_size=>16
          array :layer_b, :type=>:char, :initial_size=>16
          boolean :filtered
          v_n_m_fragment_id :mapping
        end
        class Noise < BinData::Record
          uint8 :type
          v_n_m_fragment_id :mapping
        end
        class Blender < BinData::Record
          uint8 :type
          v_n_m_fragment_id :data_a
          v_n_m_fragment_id :data_b
          v_n_m_fragment_id :control
        end
        class Clamp < BinData::Record
          boolean :min
          double :red 
          double :green
          double :blue
          v_n_m_fragment_id :data
        end
        class Matrix < BinData::Record
          layout :matrix, [:double, 16],
                 :data, :VNMFragmentID
        end

        class Ramp < BinData::Record
          uint8 :type
          uint8 :channel
          v_n_m_fragment_id :mapping
          uint8 :point_count, :uint8,
          array :ramp, :type=>VNMRampPoint, :initial_size=>48
        end
        class Animation < BinData::Record
          array :label, :type=>:char, :initial_size=>1
        end
        class Alternative < BinData::Record
          v_n_m_fragment_id :alt_a
          v_n_m_fragment_id :alt_b
        end
        class Output < BinData::Record
          v_n_m_fragment_id :label, :type=>:char, :initial_size=>16
          v_n_m_fragment_id :front
          v_n_m_fragment_id :back
        end
      end

      class VMatFrag < BinData::Record 
        MaterialFragment::Color,       :color
        MaterialFragment::Reflection,  :reflection
        MaterialFragment::Transparency :transparency
        MaterialFragment::Volume,      :volume
        MaterialFragment::Geometry,    :geometry
        MaterialFragment::Texture,     :texture
        MaterialFragment::Noise,       :noise
        MaterialFragment::Blender,     :blender
        MaterialFragment::Clamp,       :clamp
        MaterialFragment::Matrix,      :matrix
        MaterialFragment::Ramp,        :ramp
        MaterialFragment::Animation,   :animation
        MaterialFragment::Alternative, :alternative
        MaterialFragment::Output       :output

      end
      class VNBTile < BinData::Record 
        array :vuint1, :type=>:uint8, :initial_size => 8
        array :vuint8, :type=>:uint8, :initial_size => 64
        array :vuint16, :type=>:uint16, :initial_size => 64
        array :vreal32, :type=>:float, :initial_size => 64
        array :vreal64, :type=>:double, :initial_size => 64
      end
      # verse.h: "Audio commands take pointers to blocks of these. They are not packed as unions."
      # FIXME: could have sworn I could use VNAConstants directly here
      class VNABlock < BinData::Record
      	array :vint8,    :type=>:int8, :initial_size => 1024
      	array :vint16,   :type=>:int16, :initial_size => 512
      	array :vint24,   :type=>:int32, :initial_size => 384
      	array :vint32,   :type=>:int32, :initial_size => 256
      	array :vreal32,  :type=>:float, :initial_size => 256
      	array :vreal64,  :type=>:double, :initial_size => 128
      end
   end
end
