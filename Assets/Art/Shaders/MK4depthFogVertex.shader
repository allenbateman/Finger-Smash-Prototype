// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4 Toon/Depth Fog Vertex"
{
	Properties
	{
		_Color("Color", Color) = (0,1,0.6275863,0)
		_FogIntensity("FogIntensity", Range( 0 , 1)) = 0
		_FogOpacity("FogOpacity", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 2.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 screenPos;
		};

		uniform float4 _Color;
		uniform sampler2D _CameraDepthTexture;
		uniform float _FogOpacity;
		uniform float _FogIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = _Color.rgb;
			float3 appendResult18 = (float3(i.vertexColor.r , i.vertexColor.g , i.vertexColor.b));
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float eyeDepth2 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float clampResult15 = clamp( ( abs( ( eyeDepth2 - ase_screenPos.w ) ) * _FogOpacity ) , 0.0 , _FogIntensity );
			o.Alpha = ( appendResult18 * clampResult15 ).x;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
7;314;1361;662;1321.277;611.051;1.594418;True;True
Node;AmplifyShaderEditor.ScreenPosInputsNode;1;-950.5,88.5;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;2;-696.5,51.5;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-523.5533,144.4091;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;12;-311.5533,112.3934;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-464.2303,330.4028;Float;False;Property;_FogOpacity;FogOpacity;2;0;Create;True;0;0;False;0;0;0.132;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-394.1631,482.1056;Float;False;Property;_FogIntensity;FogIntensity;1;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-183.5043,201.9209;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;17;-555.1783,-447.7181;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;15;-4.163187,262.4057;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-307.1786,-415.7172;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;11;-400.5,-226.2;Float;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;0,1,0.6275863,0;0.3676471,0.8168357,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;195.0143,88.89857;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;368.7003,-133.418;Float;False;True;0;Float;ASEMaterialInspector;0;0;Standard;MK4 Toon/Depth Fog Vertex;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;3;0;2;0
WireConnection;3;1;1;4
WireConnection;12;0;3;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;15;0;13;0
WireConnection;15;2;16;0
WireConnection;18;0;17;1
WireConnection;18;1;17;2
WireConnection;18;2;17;3
WireConnection;19;0;18;0
WireConnection;19;1;15;0
WireConnection;0;2;11;0
WireConnection;0;9;19;0
ASEEND*/
//CHKSM=60410826343FA1B0C248A4184D4A38BEE85CC48E