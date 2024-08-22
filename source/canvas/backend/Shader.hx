package canvas.backend;

import cpp.Pointer;
import cpp.Helpers;
import cpp.UInt32;
import cpp.ConstCharStar;

import sys.io.File;
import sys.FileSystem;

import glad.Glad;

import canvas.math.*;

using StringTools;

/**
 * Basic OpenGL shader class used internally
 * 
 * Use `FlxShader` instead if you're using flixel components!
 */
class Shader {
	public static final VERTEX_PREFIX:String = "
		#version 330 core
		layout (location = 0) in vec4 data;
		uniform mat4 PROJECTION;
		uniform mat4 TRANSFORM;
		uniform vec4 SOURCE;
		out vec2 UV;
	";

	public static final VERTEX_DEFAULT:String = "
		void main() {
			gl_Position = PROJECTION * TRANSFORM * vec4(data.x, data.y, 0.0, 1.0);
			UV = mix(SOURCE.xy, SOURCE.zw, data.zw);
		}
	";

	public static final FRAGMENT_PREFIX:String = "
		#version 330 core
		uniform sampler2D TEXTURE;
		uniform vec4 MODULATE;
		in vec2 UV;
		out vec4 COLOR;
	";

	public static final FRAGMENT_DEFAULT:String = "
		void main() {
			COLOR = texture(TEXTURE, UV) * MODULATE;
		}
	";

	/**
	 * Makes a new `Shader` instance.
	 */
	public function new(window:Window, ?frag:String, ?vert:String) {
		var fragContent = ConstCharStar.fromString(FRAGMENT_PREFIX + ((frag != null && FileSystem.exists(frag)) ? File.getContent(frag) : (frag != null && frag.trim().length > 0) ? frag : FRAGMENT_DEFAULT));
		var vertContent = ConstCharStar.fromString(VERTEX_PREFIX + ((vert != null && FileSystem.exists(vert)) ? File.getContent(vert) : (vert != null && vert.trim().length > 0) ? vert : VERTEX_DEFAULT));
		
        var success:Int = 0;

		var vertID:UInt32 = Glad.createShader(Glad.VERTEX_SHADER);
		Glad.shaderSource(vertID, 1, Helpers.tempPointer(vertContent), null);
		Glad.compileShader(vertID);
		Glad.getShaderiv(vertID, Glad.COMPILE_STATUS, Pointer.addressOf(success));

		if (success == 0) {
			var infoLog:cpp.Star<cpp.Char> = Helpers.malloc(1024, cpp.Char);
			Glad.getShaderInfoLog(vertID, 1024, null, infoLog);
			Helpers.nativeTrace("Failed to load Vertex Shader.\n%s\n", infoLog);
			Helpers.free(infoLog);
		}

		var fragID:UInt32 = Glad.createShader(Glad.FRAGMENT_SHADER);
		Glad.shaderSource(fragID, 1, Helpers.tempPointer(fragContent), null);
		Glad.compileShader(fragID);
		Glad.getShaderiv(fragID, Glad.COMPILE_STATUS, Pointer.addressOf(success));

		if (success == 0) {
			var infoLog:cpp.Star<cpp.Char> = Helpers.malloc(1024, cpp.Char);
			Glad.getShaderInfoLog(fragID, 1024, null, infoLog);
			Helpers.nativeTrace("Failed to load Fragment Shader.\n%s\n", infoLog);
			Helpers.free(infoLog);
		}

		_program = Glad.createProgram();

		Glad.attachShader(_program, vertID);
		Glad.attachShader(_program, fragID);
		Glad.linkProgram(_program);
		Glad.getProgramiv(_program, Glad.LINK_STATUS, Pointer.addressOf(success));

		if (success == 0) {
			var infoLog:cpp.Star<cpp.Char> = Helpers.malloc(1024, cpp.Char);
			Glad.getProgramInfoLog(_program, 1024, null, infoLog);
			Helpers.nativeTrace("Failed to link Shader Program.\n%s\n", infoLog);
			Helpers.free(infoLog);
		}

		Glad.deleteShader(vertID);
		Glad.deleteShader(fragID);

		Glad.useProgram(_program);

		@:privateAccess
		setUniformMat4x4("PROJECTION", window._projection);
	}

	/**
	 * Sets this shader as the active shader in OpenGL.
	 */
	public function use() {
		Glad.useProgram(_program);
	}

	public function setUniformInt(name:ConstCharStar, value:Int) {
		untyped __cpp__("glUniform1i(glGetUniformLocation({0}, {1}), {2})", _program, name, value);
	}

	public function setUniformFloat(name:ConstCharStar, value:Float) {
		untyped __cpp__("glUniform1f(glGetUniformLocation({0}, {1}), {2})", _program, name, value);
	}

	public function setUniformVec2(name:ConstCharStar, value:Vector2) {
		untyped __cpp__("glUniform2f(glGetUniformLocation({0}, {1}), {2}, {3})", _program, name, value.x, value.y);
	}

	public function setUniformVec3(name:ConstCharStar, value:Vector3) {
		untyped __cpp__("glUniform3f(glGetUniformLocation({0}, {1}), {2}, {3}, {4})", _program, name, value.x, value.y, value.z);
	}

	public function setUniformVec4(name:ConstCharStar, value:Vector4) {
		untyped __cpp__("glUniform4f(glGetUniformLocation({0}, {1}), {2}, {3}, {4}, {5})", _program, name, value.x, value.y, value.z, value.w);
	}

	public function setUniformColor(name:ConstCharStar, value:Color) {
		untyped __cpp__("glUniform4f(glGetUniformLocation({0}, {1}), {2}, {3}, {4}, {5})", _program, name, value.r, value.g, value.b, value.a);
	}

	public function setUniformMat4x4(name:ConstCharStar, value:Matrix4x4) {
		untyped __cpp__("
			float* _star = {0};
			glUniformMatrix4fv(glGetUniformLocation({1}, {2}), 1, GL_FALSE, _star);
			free(_star)", value.toStar(), _program, name);
	}

	// --------------- //
	// [ Private API ] //
	// --------------- //

	private var _program:UInt32;
}