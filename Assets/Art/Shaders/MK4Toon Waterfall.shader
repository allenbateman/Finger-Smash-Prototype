// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4 Toon/Waterfall"
{
	Properties
	{
		_Color("Color", Color) = (0.6838235,0.764503,1,0)
		_Waterfall1("Waterfall1", 2D) = "white" {}
		_Waterfall2("Waterfall2", 2D) = "white" {}
		_Gloss("Gloss", Range( 0 , 1)) = 0
		_Specular("Specular", Range( 0 , 1)) = 0
		_Normal1("Normal1", 2D) = "bump" {}
		_Normal2("Normal2", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range( 0 , 5)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _NormalIntensity;
		uniform sampler2D _Normal1;
		uniform sampler2D _Normal2;
		uniform float4 _Color;
		uniform sampler2D _Waterfall1;
		uniform sampler2D _Waterfall2;
		uniform float _Specular;
		uniform float _Gloss;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 panner4 = ( 1.0 * _Time.y * float2( 0,1 ) + i.uv_texcoord);
			float2 panner9 = ( 1.0 * _Time.y * float2( 0,0.5 ) + i.uv_texcoord);
			o.Normal = BlendNormals( UnpackScaleNormal( tex2D( _Normal1, panner4 ), _NormalIntensity ) , UnpackScaleNormal( tex2D( _Normal2, panner9 ), _NormalIntensity ) );
			float4 tex2DNode1 = tex2D( _Waterfall1, panner4 );
			float4 tex2DNode2 = tex2D( _Waterfall2, panner9 );
			float4 lerpResult7 = lerp( tex2DNode1 , tex2DNode2 , tex2DNode1.a);
			o.Albedo = ( _Color * lerpResult7 ).rgb;
			float3 temp_cast_1 = (_Specular).xxx;
			o.Specular = temp_cast_1;
			o.Smoothness = _Gloss;
			o.Alpha = ( i.vertexColor * ( tex2DNode1.a + tex2DNode2.a ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
115;375;1272;624;752.6029;190.6123;1.3;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1439.433,-42.52452;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;9;-1173.09,174.5315;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;4;-1128.631,-89.25428;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1326.995,558.9049;Float;False;Property;_NormalIntensity;Normal Intensity;7;0;Create;True;0;0;False;0;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-927.9867,-106.7214;Float;True;Property;_Waterfall1;Waterfall1;1;0;Create;True;0;0;False;0;bb7679e4a90251745b0d74243ddae4b5;bb7679e4a90251745b0d74243ddae4b5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-949.5171,171.1299;Float;True;Property;_Waterfall2;Waterfall2;2;0;Create;True;0;0;False;0;79942d02ef6ebad46bc22ff74454d50b;79942d02ef6ebad46bc22ff74454d50b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;7;-504.5491,-13.54193;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;5;-557.0638,-205.7275;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;-162.0424,-395.8416;Float;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;0.6838235,0.764503,1,0;0.8088235,0.8655171,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-476.3622,234.6731;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-973.7762,444.3724;Float;True;Property;_Normal1;Normal1;5;0;Create;True;0;0;False;0;None;469e586d7b8e93740b61b77ddbba7cd8;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-979.0316,623.0549;Float;True;Property;_Normal2;Normal2;6;0;Create;True;0;0;False;0;None;3e73256bf73d13f46970d253bf32ce89;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;13;-607.5393,478.1014;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-146.8029,458.0872;Float;False;Property;_Specular;Specular;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-232.7975,148.5642;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-296.545,350.2941;Float;False;Property;_Gloss;Gloss;3;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;48.9685,-175.4857;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;235.0536,-34.08353;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;MK4 Toon/Waterfall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;3;0
WireConnection;4;0;3;0
WireConnection;1;1;4;0
WireConnection;2;1;9;0
WireConnection;7;0;1;0
WireConnection;7;1;2;0
WireConnection;7;2;1;4
WireConnection;10;0;1;4
WireConnection;10;1;2;4
WireConnection;11;1;4;0
WireConnection;11;5;17;0
WireConnection;12;1;9;0
WireConnection;12;5;17;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;6;0;5;0
WireConnection;6;1;10;0
WireConnection;15;0;16;0
WireConnection;15;1;7;0
WireConnection;0;0;15;0
WireConnection;0;1;13;0
WireConnection;0;3;18;0
WireConnection;0;4;14;0
WireConnection;0;9;6;0
ASEEND*/
//CHKSM=988AFBE60988AEDFCF9C859E9FF04EDD94D09AF1