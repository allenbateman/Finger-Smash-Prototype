// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4 Toon/Skybox"
{
	Properties
	{
		[Gamma][Header(Cubemap)]_TintColor("Tint Color", Color) = (0.5,0.5,0.5,1)
		_Exposure("Exposure", Range( 0 , 8)) = 1
		_Gradient1Color("Gradient 1 Color", Color) = (1,0.8722109,0.5367647,0)
		[Toggle(_GRADIENT1ISGLOBALFOG_ON)] _Gradient1isGlobalFog("Gradient 1 is Global Fog", Float) = 0
		_Gradient2Color("Gradient 2 Color", Color) = (0.3235294,0.6081135,1,0)
		_Gradient1Height("Gradient 1 Height", Range( 0 , 1)) = 0.4
		_Gradient1Smoothness("Gradient 1 Smoothness", Range( 0 , 1)) = 0.01
		_Gradient1Intensity("Gradient 1 Intensity", Range( 0 , 1)) = 0.8
		_Gradient2Height("Gradient 2 Height", Range( 0 , 1)) = 1
		_Gradient2Smoothness("Gradient 2 Smoothness", Range( 0 , 1)) = 0
		_Gradient2Intensity("Gradient 2 Intensity", Range( 0 , 1)) = 0.5
		_MainRotation("Main Rotation", Range( 0 , 360)) = 0
		_RotationSpeed("Rotation Speed", Range( 0 , 1)) = 0.1
		[HDR][NoScaleOffset]_Background("Background", CUBE) = "gray" {}
		[Toggle(_BACKGRONDTEXTURE_ON)] _BackgrondTexture("Backgrond Texture", Float) = 0
		[HDR]_BacgroundColor("Bacground Color", Color) = (0.2627451,0.5490196,0.9960785,0)
		_Ground("Ground", Color) = (0.4044118,0.3584746,0.2378893,0)
		_GroundIntensity("Ground Intensity", Range( 0 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Background"  "Queue" = "Background+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  "PreviewType"="Skybox" }
		LOD 100
		Cull Off
		ZWrite Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma shader_feature _GRADIENT1ISGLOBALFOG_ON
		#pragma shader_feature _BACKGRONDTEXTURE_ON
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float3 vertexToFrag774;
			float3 worldPos;
		};

		uniform float4 _Gradient1Color;
		uniform float4 _Ground;
		uniform float4 _Gradient2Color;
		uniform float4 _BacgroundColor;
		uniform samplerCUBE _Background;
		uniform float _MainRotation;
		uniform float _RotationSpeed;
		uniform half _Gradient2Height;
		uniform half _Gradient2Smoothness;
		uniform half _Gradient2Intensity;
		uniform float _GroundIntensity;
		uniform half _Gradient1Height;
		uniform half _Gradient1Smoothness;
		uniform half _Gradient1Intensity;
		uniform half4 _TintColor;
		uniform half _Exposure;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float temp_output_47_0 = radians( ( _MainRotation + ( _Time.y * (0.0 + (_RotationSpeed - 0.0) * (6.0 - 0.0) / (1.0 - 0.0)) ) ) );
			float3 appendResult56 = (float3(cos( temp_output_47_0 ) , 0.0 , ( sin( temp_output_47_0 ) * -1.0 )));
			float lerpResult268 = lerp( 1.0 , ( unity_OrthoParams.y / unity_OrthoParams.x ) , unity_OrthoParams.w);
			float3 appendResult266 = (float3(0.0 , lerpResult268 , 0.0));
			float3 appendResult58 = (float3(sin( temp_output_47_0 ) , 0.0 , cos( temp_output_47_0 )));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 normalizeResult247 = normalize( ase_worldPos );
			o.vertexToFrag774 = mul( float3x3(appendResult56, appendResult266, appendResult58), normalizeResult247 );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			#ifdef _GRADIENT1ISGLOBALFOG_ON
				float4 staticSwitch1211 = unity_FogColor;
			#else
				float4 staticSwitch1211 = _Gradient1Color;
			#endif
			#ifdef _BACKGRONDTEXTURE_ON
				float4 staticSwitch1219 = texCUBE( _Background, i.vertexToFrag774 );
			#else
				float4 staticSwitch1219 = _BacgroundColor;
			#endif
			half4 Output1216 = staticSwitch1219;
			float3 ase_worldPos = i.worldPos;
			float3 normalizeResult319 = normalize( ase_worldPos );
			float temp_output_314_0 = abs( normalizeResult319.y );
			float clampResult1200 = clamp( pow( (0.0 + (temp_output_314_0 - 0.0) * (0.6 - 0.0) / (_Gradient2Height - 0.0)) , ( 1.0 - (0.01 + (_Gradient2Smoothness - 0.0) * (1.0 - 0.01) / (1.0 - 0.0)) ) ) , 0.0 , 1.0 );
			float lerpResult1209 = lerp( clampResult1200 , 1.0 , ( 1.0 - _Gradient2Intensity ));
			float4 lerpResult1199 = lerp( _Gradient2Color , Output1216 , lerpResult1209);
			float clampResult1223 = clamp( (0.0 + (ase_worldPos.y - 0.0) * (1.0 - 0.0) / (0.0 - 0.0)) , 0.0 , 1.0 );
			float lerpResult1234 = lerp( clampResult1223 , 1.0 , ( 1.0 - _GroundIntensity ));
			float4 lerpResult1236 = lerp( _Ground , lerpResult1199 , lerpResult1234);
			float clampResult1198 = clamp( pow( (0.0 + (temp_output_314_0 - 0.0) * (1.0 - 0.0) / (_Gradient1Height - 0.0)) , ( 1.0 - (0.01 + (_Gradient1Smoothness - 0.0) * (1.0 - 0.01) / (1.0 - 0.0)) ) ) , 0.0 , 1.0 );
			float lerpResult678 = lerp( clampResult1198 , 1.0 , ( 1.0 - _Gradient1Intensity ));
			float4 lerpResult317 = lerp( staticSwitch1211 , lerpResult1236 , lerpResult678);
			o.Emission = ( lerpResult317 * unity_ColorSpaceDouble * _TintColor * _Exposure ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
}
/*ASEBEGIN
Version=16100
328;346;1186;624;3114.115;-521.6879;2.605932;True;True
Node;AmplifyShaderEditor.RangedFloatNode;1192;-4255.534,-1125.219;Float;False;Property;_RotationSpeed;Rotation Speed;13;0;Create;True;0;0;False;0;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1193;-3974.133,-1157.318;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;1194;-3940.704,-1302.011;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1196;-3822.886,-1043.699;Float;False;Property;_MainRotation;Main Rotation;12;0;Create;True;0;0;False;0;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;255;-3712.424,-1172.195;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;276;-3551.154,-1179.091;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OrthoParams;267;-4192.723,-819.4712;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RadiansOpNode;47;-3397.865,-1171.462;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;309;-3888.721,-819.4712;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;59;-3169.832,-1116.763;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-2977.832,-1116.763;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;268;-3552.721,-819.4712;Float;False;3;0;FLOAT;1;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;365;-3169.832,-732.7626;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;55;-3169.832,-1180.763;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;61;-3169.832,-796.7625;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;318;-3516.738,-122.6394;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;266;-2785.832,-988.7625;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;238;-2520.488,-890.8404;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;56;-2785.832,-1180.763;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-2785.832,-796.7625;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;319;-3260.738,-122.6394;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;247;-2334,-870.7413;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors;54;-2549.606,-1012.683;Float;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;320;-3068.738,-122.6394;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1201;-3033.115,657.8485;Half;False;Property;_Gradient2Smoothness;Gradient 2 Smoothness;9;0;Create;True;0;0;False;0;0;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-2164.432,-1004.688;Float;False;2;2;0;FLOAT3x3;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;1202;-2674.811,633.2722;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.01;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1203;-3035.88,520.7194;Half;False;Property;_Gradient2Height;Gradient 2 Height;8;0;Create;True;0;0;False;0;1;0.693;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;314;-2748.737,-122.6394;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;774;-1990.699,-990.7424;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;325;-3022.775,149.5321;Half;False;Property;_Gradient1Smoothness;Gradient 1 Smoothness;6;0;Create;True;0;0;False;0;0.01;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1205;-2567.077,386.977;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1204;-2471.877,605.576;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1220;-1695.194,-1248.464;Float;False;Property;_BacgroundColor;Bacground Color;16;1;[HDR];Create;True;0;0;False;0;0.2627451,0.5490196,0.9960785,0;0.2627451,0.5490196,0.9960785,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1217;-1703.705,-1042.074;Float;True;Property;_Background;Background;14;2;[HDR];[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;gray;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;1197;-2664.47,123.6559;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.01;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;313;-3025.54,11.1031;Half;False;Property;_Gradient1Height;Gradient 1 Height;5;0;Create;True;0;0;False;0;0.4;0.693;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1206;-2269.069,659.025;Half;False;Property;_Gradient2Intensity;Gradient 2 Intensity;10;0;Create;True;0;0;False;0;0.5;0.379;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1208;-2311.077,386.977;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1222;-2265.787,1116.324;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;1219;-1351.23,-1093.258;Float;False;Property;_BackgrondTexture;Backgrond Texture;15;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;1200;-2062.78,400.6435;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1224;-1926.278,1396.761;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1215;-1939.287,593.0152;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1235;-1725.602,1644.419;Float;False;Property;_GroundIntensity;Ground Intensity;18;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;315;-2556.737,-122.6394;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;329;-2461.537,95.95964;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1216;-356.5661,-881.9088;Half;False;Output;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1237;-1418.912,1445.718;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;228;-1145.119,351.2628;Float;False;1216;Output;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;679;-2182.137,191.3599;Half;False;Property;_Gradient1Intensity;Gradient 1 Intensity;7;0;Create;True;0;0;False;0;0.8;0.379;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1209;-1863.075,386.977;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1223;-1609.784,1381.668;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1210;-1104.126,130.7041;Float;False;Property;_Gradient2Color;Gradient 2 Color;4;0;Create;True;0;0;False;0;0.3235294,0.6081135,1,0;0.7647059,0.5667045,0.1405709,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;677;-2300.737,-122.6394;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1199;-749.0865,196.0559;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;312;-1126.407,-210.4628;Float;False;unity_FogColor;0;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1214;-1871.832,180.8247;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1226;-781.8207,380.2064;Float;False;Property;_Ground;Ground;17;0;Create;True;0;0;False;0;0.4044118,0.3584746,0.2378893,0;0.4044118,0.3584746,0.2378893,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1234;-1278.81,1191.212;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1212;-1097.374,-124.2187;Float;False;Property;_Gradient1Color;Gradient 1 Color;2;0;Create;True;0;0;False;0;1,0.8722109,0.5367647,0;1,0.9241379,0.5,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;1198;-2013.568,-105.4391;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;1211;-756.9137,-140.9136;Float;False;Property;_Gradient1isGlobalFog;Gradient 1 is Global Fog;3;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1236;-453.3774,311.842;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;678;-1827.829,-111.0156;Float;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1173;-336.6917,-320.7914;Half;False;Property;_TintColor;Tint Color;0;1;[Gamma];Create;True;0;0;False;1;Header(Cubemap);0.5,0.5,0.5,1;0.5,0.5,0.5,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1177;-323.3807,-133.2612;Half;False;Property;_Exposure;Exposure;1;0;Create;True;0;0;False;0;1;2.12;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;317;-182.6141,164.2324;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorSpaceDouble;1175;-336.6917,-496.7913;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;1228;-1971.609,1061.777;Float;True;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ClampOpNode;1229;-1665.835,1095.258;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1174;126.0583,104.9438;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;62;-3241.973,-1249.531;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;26;407.2156,-85.01405;Float;False;True;0;Float;;100;0;Unlit;MK4 Toon/Skybox;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;True;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0;True;False;0;True;Background;;Background;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;100;;11;-1;-1;-1;1;PreviewType=Skybox;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1193;0;1192;0
WireConnection;255;0;1194;2
WireConnection;255;1;1193;0
WireConnection;276;0;1196;0
WireConnection;276;1;255;0
WireConnection;47;0;276;0
WireConnection;309;0;267;2
WireConnection;309;1;267;1
WireConnection;59;0;47;0
WireConnection;60;0;59;0
WireConnection;268;1;309;0
WireConnection;268;2;267;4
WireConnection;365;0;47;0
WireConnection;55;0;47;0
WireConnection;61;0;47;0
WireConnection;266;1;268;0
WireConnection;56;0;55;0
WireConnection;56;2;60;0
WireConnection;58;0;61;0
WireConnection;58;2;365;0
WireConnection;319;0;318;0
WireConnection;247;0;238;0
WireConnection;54;0;56;0
WireConnection;54;1;266;0
WireConnection;54;2;58;0
WireConnection;320;0;319;0
WireConnection;49;0;54;0
WireConnection;49;1;247;0
WireConnection;1202;0;1201;0
WireConnection;314;0;320;1
WireConnection;774;0;49;0
WireConnection;1205;0;314;0
WireConnection;1205;2;1203;0
WireConnection;1204;0;1202;0
WireConnection;1217;1;774;0
WireConnection;1197;0;325;0
WireConnection;1208;0;1205;0
WireConnection;1208;1;1204;0
WireConnection;1219;1;1220;0
WireConnection;1219;0;1217;0
WireConnection;1200;0;1208;0
WireConnection;1224;0;1222;2
WireConnection;1215;0;1206;0
WireConnection;315;0;314;0
WireConnection;315;2;313;0
WireConnection;329;0;1197;0
WireConnection;1216;0;1219;0
WireConnection;1237;0;1235;0
WireConnection;1209;0;1200;0
WireConnection;1209;2;1215;0
WireConnection;1223;0;1224;0
WireConnection;677;0;315;0
WireConnection;677;1;329;0
WireConnection;1199;0;1210;0
WireConnection;1199;1;228;0
WireConnection;1199;2;1209;0
WireConnection;1214;0;679;0
WireConnection;1234;0;1223;0
WireConnection;1234;2;1237;0
WireConnection;1198;0;677;0
WireConnection;1211;1;1212;0
WireConnection;1211;0;312;0
WireConnection;1236;0;1226;0
WireConnection;1236;1;1199;0
WireConnection;1236;2;1234;0
WireConnection;678;0;1198;0
WireConnection;678;2;1214;0
WireConnection;317;0;1211;0
WireConnection;317;1;1236;0
WireConnection;317;2;678;0
WireConnection;1228;0;1222;0
WireConnection;1229;0;1228;1
WireConnection;1174;0;317;0
WireConnection;1174;1;1175;0
WireConnection;1174;2;1173;0
WireConnection;1174;3;1177;0
WireConnection;62;0;47;0
WireConnection;26;2;1174;0
ASEEND*/
//CHKSM=F7BF517E8BB3722E481A5A517440FDEDFBA47162