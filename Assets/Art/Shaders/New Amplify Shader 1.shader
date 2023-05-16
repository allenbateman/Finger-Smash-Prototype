// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4 Toon/Fresnel"
{
	Properties
	{
		[HDR]_Color1("Color 1", Color) = (0,0.3534337,0.8161765,0)
		[HDR]_Color2("Color 2", Color) = (0.07352942,0.8447917,1,0)
		_Power("Power", Range( 0 , 1)) = 0.1595071
		_Scale("Scale", Range( 0 , 1)) = 0.59
		_Bias("Bias", Range( 0 , 1)) = 0.42
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1 = ( (-0.5 + (_Bias - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) + (0.0 + (_Scale - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) * pow( 1.0 - fresnelNdotV1, (0.0 + (_Power - 0.0) * (10.0 - 0.0) / (1.0 - 0.0)) ) );
			float clampResult11 = clamp( fresnelNode1 , 0.0 , 1.0 );
			float4 lerpResult4 = lerp( _Color1 , _Color2 , clampResult11);
			o.Emission = lerpResult4.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
82;409;1272;624;1812.349;425.4775;1.945304;True;True
Node;AmplifyShaderEditor.RangedFloatNode;8;-1650.54,165.2746;Float;False;Property;_Scale;Scale;3;0;Create;True;0;0;False;0;0.59;0.79;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1651.73,318.9021;Float;False;Property;_Power;Power;2;0;Create;True;0;0;False;0;0.1595071;0.072;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1648.285,-5.705274;Float;False;Property;_Bias;Bias;4;0;Create;True;0;0;False;0;0.42;0.519;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;6;-1280.678,-2.766889;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;9;-1308.699,306.8676;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;7;-1285.284,158.5359;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-1044.914,156.5521;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.82;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-620.6929,-41.74757;Float;False;Property;_Color2;Color 2;1;1;[HDR];Create;True;0;0;False;0;0.07352942,0.8447917,1,0;0.2867647,0.7624614,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-619.4286,-274.388;Float;False;Property;_Color1;Color 1;0;1;[HDR];Create;True;0;0;False;0;0,0.3534337,0.8161765,0;0,0.3534337,0.8161765,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;11;-705.3219,171.7952;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;-277.2311,24.66931;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;237.5308,-2.349965;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MK4 Toon/Fresnel;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;9;0;10;0
WireConnection;7;0;8;0
WireConnection;1;1;6;0
WireConnection;1;2;7;0
WireConnection;1;3;9;0
WireConnection;11;0;1;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;4;2;11;0
WireConnection;0;2;4;0
ASEEND*/
//CHKSM=F4FA4EECCA469761E7D5E5AB5D11E8701470B31B