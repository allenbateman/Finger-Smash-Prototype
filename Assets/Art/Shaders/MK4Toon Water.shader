// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4 Toon/Water"
{
	Properties
	{
		_Normal("Normal", 2D) = "bump" {}
		_Specular("Specular", Range( 0 , 1)) = 0
		_TextureSample2("Texture Sample 2", 2D) = "bump" {}
		_Color("Color", Color) = (0.3892733,0.6493855,0.7352941,0)
		_Gloss("Gloss", Range( 0 , 1)) = 0.5
		_NormalIntensity("Normal Intensity", Range( 0 , 2)) = 1
		_WaveScale("Wave Scale", Range( 0 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform float _NormalIntensity;
		uniform float _WaveScale;
		uniform sampler2D _TextureSample2;
		uniform float4 _Color;
		uniform float _Specular;
		uniform float _Gloss;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult3 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner8 = ( 1.0 * _Time.y * float2( 0.08,0.1 ) + ( appendResult3 * float2( 0.3,0.3 ) ));
			float temp_output_24_0 = (0.3 + (_WaveScale - 0.0) * (2.0 - 0.3) / (1.0 - 0.0));
			float2 panner11 = ( 1.0 * _Time.y * float2( -0.07,-0.04 ) + ( appendResult3 * float2( 0.2,0.2 ) ));
			float2 panner19 = ( 1.0 * _Time.y * float2( -0.01,0.05 ) + ( appendResult3 * float2( 0.15,0.15 ) ));
			o.Normal = BlendNormals( BlendNormals( UnpackScaleNormal( tex2D( _Normal, ( panner8 * temp_output_24_0 ) ), _NormalIntensity ) , UnpackScaleNormal( tex2D( _Normal, ( panner11 * temp_output_24_0 ) ), _NormalIntensity ) ) , UnpackScaleNormal( tex2D( _TextureSample2, ( panner19 * temp_output_24_0 ) ), _NormalIntensity ) );
			o.Albedo = _Color.rgb;
			float3 temp_cast_1 = (_Specular).xxx;
			o.Specular = temp_cast_1;
			o.Smoothness = _Gloss;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
7;409;1186;624;1465.221;176.6138;2.142387;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-1800.816,1.958411;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;3;-1532.313,39.12982;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1360.249,48.39092;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.3,0.3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1348.078,235.8723;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.2,0.2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1535.814,577.751;Float;False;Property;_WaveScale;Wave Scale;6;0;Create;True;0;0;False;0;1;0.302;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;11;-1159.885,246.8309;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.07,-0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1365.604,402.5158;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.15,0.15;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;8;-1160.71,109.9138;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.08,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;24;-1238.086,561.2527;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.3;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-868.9415,-273.434;Float;True;Property;_Normal;Normal;0;0;Create;True;0;0;True;0;11fc85105913c1742a82a9e2a8b1a148;11fc85105913c1742a82a9e2a8b1a148;True;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;19;-1158.733,394.0019;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.01,0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-915.4943,129.424;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1031.669,689.5679;Float;False;Property;_NormalIntensity;Normal Intensity;5;0;Create;True;0;0;False;0;1;0.46;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-905.2531,262.5568;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-906.9598,376.9148;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;9;-644.7576,296.395;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;11fc85105913c1742a82a9e2a8b1a148;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.2;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-637.6201,89.28787;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;11fc85105913c1742a82a9e2a8b1a148;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.2;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-627.0792,522.5123;Float;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;False;0;None;11fc85105913c1742a82a9e2a8b1a148;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.2;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;12;-223.3447,263.7941;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;6;-165.8084,-254.2892;Float;False;Property;_Color;Color;3;0;Create;True;0;0;False;0;0.3892733,0.6493855,0.7352941,0;0.2815744,0.4840861,0.6838235,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-29.68737,101.402;Float;False;Property;_Specular;Specular;1;0;Create;True;0;0;False;0;0;0.354;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;18;-27.00903,459.0902;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-32.31223,204.2469;Float;False;Property;_Gloss;Gloss;4;0;Create;True;0;0;False;0;0.5;0.711;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;317.7989,19.74456;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;MK4 Toon/Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;1
WireConnection;3;1;2;3
WireConnection;5;0;3;0
WireConnection;10;0;3;0
WireConnection;11;0;10;0
WireConnection;16;0;3;0
WireConnection;8;0;5;0
WireConnection;24;0;23;0
WireConnection;19;0;16;0
WireConnection;22;0;8;0
WireConnection;22;1;24;0
WireConnection;21;0;11;0
WireConnection;21;1;24;0
WireConnection;20;0;19;0
WireConnection;20;1;24;0
WireConnection;9;0;4;0
WireConnection;9;1;21;0
WireConnection;9;5;15;0
WireConnection;7;0;4;0
WireConnection;7;1;22;0
WireConnection;7;5;15;0
WireConnection;17;1;20;0
WireConnection;17;5;15;0
WireConnection;12;0;7;0
WireConnection;12;1;9;0
WireConnection;18;0;12;0
WireConnection;18;1;17;0
WireConnection;0;0;6;0
WireConnection;0;1;18;0
WireConnection;0;3;13;0
WireConnection;0;4;14;0
ASEEND*/
//CHKSM=B47F1EC21D6301BD88BFF0787AFCBAC4EB4B8A8C