// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4 Toon/Standard Glow Anim"
{
	Properties
	{
		_BaseColor("Base Color", 2D) = "gray" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_Noise("Noise", 2D) = "black" {}
		[HDR]_Emission("Emission", Color) = (0,0.4196079,0.9058824,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform sampler2D _BaseColor;
		uniform float4 _Emission;
		uniform sampler2D _Noise;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = UnpackNormal( tex2D( _NormalMap, i.uv_texcoord ) );
			float4 tex2DNode1 = tex2D( _BaseColor, i.uv_texcoord );
			float4 lerpResult11 = lerp( tex2DNode1 , _Emission , tex2DNode1.a);
			o.Albedo = lerpResult11.rgb;
			float2 panner8 = ( 1.0 * _Time.y * float2( 0.04,0.02 ) + ( i.uv_texcoord * float2( 0.6,0.6 ) ));
			float2 panner9 = ( 1.0 * _Time.y * float2( -0.04,-0.07 ) + i.uv_texcoord);
			float4 clampResult17 = clamp( ( tex2DNode1.a * ( tex2D( _Noise, panner8 ) * tex2D( _Noise, panner9 ) ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = ( clampResult17 * _Emission ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
7;409;1186;624;1749.355;300.9856;1.836384;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1466.398,-66.63241;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1423.579,452.5617;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.6,0.6;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;9;-1216.65,588.8829;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.04,-0.07;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;8;-1216.861,440.0193;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.02;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;6;-1178.233,207.9203;Float;True;Property;_Noise;Noise;2;0;Create;True;0;0;False;0;None;bc67dfe38de9bb849bbf8bb1f7307ccd;False;black;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;10;-925.9395,620.5966;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-915.3328,403.2038;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-611.7406,491.4217;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-923.2966,-34.21757;Float;True;Property;_BaseColor;Base Color;0;0;Create;True;0;0;False;0;None;c64fb3c7cbfe9944a845d9baae879379;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-434.9529,418.5761;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;17;-255.2729,402.1749;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;4;-594.8078,-145.5141;Float;False;Property;_Emission;Emission;3;1;[HDR];Create;True;0;0;False;0;0,0.4196079,0.9058824,0;0,0.4196079,0.9058824,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-91.6739,274.1396;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;-297.5959,107.6127;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-929.9326,170.4356;Float;True;Property;_NormalMap;Normal Map;1;0;Create;True;0;0;False;0;None;3959d86d657e07d4db4099041e6cd6fd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;205.3412,135.421;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MK4 Toon/Standard Glow Anim;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;5;0
WireConnection;9;0;5;0
WireConnection;8;0;15;0
WireConnection;10;0;6;0
WireConnection;10;1;9;0
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;16;0;7;0
WireConnection;16;1;10;0
WireConnection;1;1;5;0
WireConnection;13;0;1;4
WireConnection;13;1;16;0
WireConnection;17;0;13;0
WireConnection;14;0;17;0
WireConnection;14;1;4;0
WireConnection;11;0;1;0
WireConnection;11;1;4;0
WireConnection;11;2;1;4
WireConnection;2;1;5;0
WireConnection;0;0;11;0
WireConnection;0;1;2;0
WireConnection;0;2;14;0
ASEEND*/
//CHKSM=4BDDE8683BAB72C716AFB33C3B84E6CFB71907CE