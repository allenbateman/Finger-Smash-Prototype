// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4 Toon/ToonTrees Alpha Normal"
{
	Properties
	{
		_Freq("Freq", Range( 0 , 1)) = 0.8
		_BendAmount("Bend Amount", Range( 0 , 1)) = 0
		_WindDirection("Wind Direction", Range( 0 , 10)) = 0.6891014
		_Texture1("Texture 1", 2D) = "gray" {}
		_Normalmap("Normalmap", 2D) = "bump" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.7
		_VectorNoise("Vector Noise", 2D) = "black" {}
		_WarpIntensity("Warp Intensity", Range( 0 , 1)) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _VectorNoise;
		uniform float _WarpIntensity;
		uniform float _WindDirection;
		uniform float _Freq;
		uniform float _BendAmount;
		uniform sampler2D _Normalmap;
		uniform float4 _Normalmap_ST;
		uniform sampler2D _Texture1;
		uniform float4 _Texture1_ST;
		uniform float _Cutoff = 0.7;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult27 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner34 = ( 1.0 * _Time.y * float2( 0.3,0.2 ) + ( appendResult27 * float2( 0.3,0.3 ) ));
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_10_0 = ( ( ase_vertex3Pos.y * cos( ( ( ( ase_worldPos.x + ase_worldPos.z ) * _Freq ) + _Time.y ) ) ) * _BendAmount );
			float4 appendResult12 = (float4(temp_output_10_0 , 0.0 , temp_output_10_0 , 0.0));
			float4 break16 = mul( appendResult12, unity_ObjectToWorld );
			float4 appendResult18 = (float4(break16.x , 0 , break16.y , 0.0));
			float3 rotatedValue19 = RotateAroundAxis( float3( 0,0,0 ), appendResult18.xyz, float3( 0,0,0 ), _WindDirection );
			v.vertex.xyz += ( ( (float4( 0,-0.5,0,0 ) + (tex2Dlod( _VectorNoise, float4( panner34, 0, 0.0) ) - float4( 0,0,0,0 )) * (float4( 0.5,1,0.5,0.5 ) - float4( 0,-0.5,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) * (0.0 + (_WarpIntensity - 0.0) * (0.3 - 0.0) / (1.0 - 0.0)) ) + float4( rotatedValue19 , 0.0 ) ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normalmap = i.uv_texcoord * _Normalmap_ST.xy + _Normalmap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normalmap, uv_Normalmap ) );
			float2 uv_Texture1 = i.uv_texcoord * _Texture1_ST.xy + _Texture1_ST.zw;
			float4 tex2DNode22 = tex2D( _Texture1, uv_Texture1 );
			o.Albedo = tex2DNode22.rgb;
			o.Alpha = 1;
			clip( tex2DNode22.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
7;409;1186;624;1479.767;1045.944;2.053571;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-2564.435,-94.82201;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-2352.802,-88.5097;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2543.601,52.77137;Float;False;Property;_Freq;Freq;0;0;Create;True;0;0;False;0;0.8;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-2216.486,-89.77756;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;6;-2106.716,69.8101;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-1973.572,-81.09476;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;8;-1857.298,-252.8511;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CosOpNode;7;-1809.509,-61.0874;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;28;-1475.522,-1057.244;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;11;-1758.739,56.7571;Float;False;Property;_BendAmount;Bend Amount;1;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1656.468,-76.81122;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;-1182.654,-1020.073;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1478.961,-70.37981;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-929.3088,-947.6713;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.3,0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-1316.32,-125.8072;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectToWorldMatrixNode;15;-1337.879,36.2046;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1142.474,-103.6121;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;34;-761.2421,-883.2969;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.3,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;26;-485.4793,-953.8613;Float;True;Property;_VectorNoise;Vector Noise;6;0;Create;True;0;0;False;0;None;8b97c3e80593993429f690283e78ff16;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-426.3864,-673.6531;Float;False;Property;_WarpIntensity;Warp Intensity;7;0;Create;True;0;0;False;0;0.2;0.35;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;17;-913.6128,-275.1832;Float;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;16;-988.4545,-108.0771;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TFHCRemapNode;35;-126.6997,-706.2391;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;25;-152.4942,-931.0557;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,-0.5,0,0;False;4;COLOR;0.5,1,0.5,0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-766.0979,99.44028;Float;False;Property;_WindDirection;Wind Direction;2;0;Create;True;0;0;False;0;0.6891014;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-693.719,-172.743;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;97.72314,-780.0029;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;19;-452.4666,-94.90443;Float;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;22;-922.1249,-662.8143;Float;True;Property;_Texture1;Texture 1;3;0;Create;True;0;0;False;0;None;f4c14c280d38e8a4688e1238b4c93f51;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;30;44.32286,-225.9757;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;37;-915.8577,-475.9218;Float;True;Property;_Normalmap;Normalmap;4;0;Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;239.1384,-322.1057;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MK4 Toon/ToonTrees Alpha Normal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.7;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;1
WireConnection;2;1;1;3
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;5;0;3;0
WireConnection;5;1;6;2
WireConnection;7;0;5;0
WireConnection;9;0;8;2
WireConnection;9;1;7;0
WireConnection;27;0;28;1
WireConnection;27;1;28;3
WireConnection;10;0;9;0
WireConnection;10;1;11;0
WireConnection;29;0;27;0
WireConnection;12;0;10;0
WireConnection;12;2;10;0
WireConnection;13;0;12;0
WireConnection;13;1;15;0
WireConnection;34;0;29;0
WireConnection;26;1;34;0
WireConnection;16;0;13;0
WireConnection;35;0;32;0
WireConnection;25;0;26;0
WireConnection;18;0;16;0
WireConnection;18;1;17;2
WireConnection;18;2;16;1
WireConnection;31;0;25;0
WireConnection;31;1;35;0
WireConnection;19;1;20;0
WireConnection;19;3;18;0
WireConnection;30;0;31;0
WireConnection;30;1;19;0
WireConnection;0;0;22;0
WireConnection;0;1;37;0
WireConnection;0;10;22;4
WireConnection;0;11;30;0
ASEEND*/
//CHKSM=30A2E5185C481B84A2ACF9CD5861CC12076A8276