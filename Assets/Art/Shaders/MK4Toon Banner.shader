// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4 Toon/Banner waving"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "gray" {}
		_Mask("Mask", 2D) = "white" {}
		_Vector("Vector", 2D) = "white" {}
		_WarpIntensity("Warp Intensity", Range( 0 , 1)) = 0.5
		_Scale("Scale", Range( 0 , 1)) = 0.5
		_Direction("Direction", Vector) = (-0.5,0,0,0)
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
			float2 uv_texcoord;
		};

		uniform sampler2D _Vector;
		uniform float2 _Direction;
		uniform float _Scale;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float _WarpIntensity;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 panner4 = ( 1.0 * _Time.y * _Direction + ( v.texcoord.xy * (0.1 + (_Scale - 0.0) * (1.0 - 0.1) / (1.0 - 0.0)) ));
			float2 uv_Mask = v.texcoord * _Mask_ST.xy + _Mask_ST.zw;
			v.vertex.xyz += ( ( (float4( -0.5,-0.5,-0.5,-0.5 ) + (tex2Dlod( _Vector, float4( panner4, 0, 0.0) ) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( -0.5,-0.5,-0.5,-0.5 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) * tex2Dlod( _Mask, float4( uv_Mask, 0, 0.0) ) ) * _WarpIntensity ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo, uv_Albedo );
			o.Albedo = tex2DNode1.rgb;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
311;454;1080;527;810.7171;-18.73212;1.441112;True;True
Node;AmplifyShaderEditor.RangedFloatNode;17;-1932.155,140.2297;Float;False;Property;_Scale;Scale;5;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1608.89,-58.74337;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;18;-1638.913,151.5933;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;19;-1328.255,209.5298;Float;False;Property;_Direction;Direction;6;0;Create;True;0;0;False;0;-0.5,0;-0.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1349.589,70.31017;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;4;-1106.929,102.0626;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.5,0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-867.7816,73.01244;Float;True;Property;_Vector;Vector;3;0;Create;True;0;0;False;0;8b97c3e80593993429f690283e78ff16;8b97c3e80593993429f690283e78ff16;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-485.9946,428.5975;Float;True;Property;_Mask;Mask;2;0;Create;True;0;0;False;0;c2b5b60d1c083ea419ffdbb8319442db;c2b5b60d1c083ea419ffdbb8319442db;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;7;-505.6344,205.7038;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;-0.5,-0.5,-0.5,-0.5;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-233.6205,134.9865;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-98.67599,306.6288;Float;False;Property;_WarpIntensity;Warp Intensity;4;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-572.2076,-157.5554;Float;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;False;0;fb7e809722580dc45b93fe4711520722;fb7e809722580dc45b93fe4711520722;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;40.07987,143.0779;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;240.5617,-161.6876;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MK4 Toon/Banner waving;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;17;0
WireConnection;16;0;5;0
WireConnection;16;1;18;0
WireConnection;4;0;16;0
WireConnection;4;2;19;0
WireConnection;2;1;4;0
WireConnection;7;0;2;0
WireConnection;6;0;7;0
WireConnection;6;1;3;0
WireConnection;14;0;6;0
WireConnection;14;1;15;0
WireConnection;0;0;1;0
WireConnection;0;10;1;4
WireConnection;0;11;14;0
ASEEND*/
//CHKSM=F25F5A6EC3E84743C154854B40B454F8606A2C53