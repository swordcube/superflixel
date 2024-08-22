package canvas.backend;

#if (!macro && !eval)
import cpp.Pointer;
import cpp.Helpers;

import sdl.SDL;
import sdl.Types.Event;
import sdl.Types.Window as NativeWindow;
import sdl.Types.WindowInitFlags;
import sdl.Types.GlContext;

import glad.Glad;

import canvas.math.Matrix4x4;

// TODO: make this real :3
/**
 * A basic window class that contains your game.
 */
class Window {
	public function new(title:String, x:Int, y:Int, width:Int, height:Int) {
        _nativeWindow = SDL.createWindow(title, x, y, width, height, RESIZABLE | OPENGL);
		_initGL(width, height);
        _event = SDL.makeEvent();
        
        while(_running)
			_update();

		SDL.glDeleteContext(_glContext);
        SDL.destroyWindow(_nativeWindow);
    }

	// --------------- //
	// [ Private API ] //
	// --------------- //
	
	private function _initGL(width:Int, height:Int) {
		_glContext = SDL.glCreateContext(_nativeWindow);

		SDL.glMakeCurrent(_nativeWindow, _glContext);
        SDL.glSetSwapInterval(0);

		Glad.loadGLLoader(untyped __cpp__("(GLADloadproc)SDL_GL_GetProcAddress"));

		final vertices:Array<cpp.Float32> = [
            // positions   // texture coords
            0.0,  0.0,     0.0, 0.0,   // top left
            0.0,  1.0,     0.0, 1.0,   // bottom left
            1.0,  1.0,     1.0, 1.0,   // bottom right
            1.0,  0.0,     1.0, 0.0    // top right 
		];
        final indices:Array<cpp.UInt32> = [
            // note that we start from 0!
            0, 1, 3, // first triangle
            1, 2, 3  // second triangle
		];

		Glad.genVertexArrays(1, Pointer.addressOf(_VAO));
        Glad.bindVertexArray(_VAO);

        Glad.genBuffers(1, Pointer.addressOf(_VBO));
        Glad.bindBuffer(Glad.ARRAY_BUFFER, _VBO);
		Glad.bufferFloatArray(Glad.ARRAY_BUFFER, vertices, Glad.STATIC_DRAW, 16);

        Glad.genBuffers(1, Pointer.addressOf(_EBO));
        Glad.bindBuffer(Glad.ELEMENT_ARRAY_BUFFER, _EBO);
		Glad.bufferIntArray(Glad.ELEMENT_ARRAY_BUFFER, indices, Glad.STATIC_DRAW, 4);
        
        _projection = Matrix4x4.ortho(0.0, width, height, 0.0, -1.0, 1.0);

        _defaultShader = new Shader(this);
        _defaultShader.use();

		Glad.vertexFloatAttrib(0, 4, Glad.FALSE, 4, 0);
        Glad.enableVertexAttribArray(0);

        Glad.enable(Glad.BLEND);
        Glad.blendFunc(Glad.SRC_ALPHA, Glad.ONE_MINUS_SRC_ALPHA);
	}

    private function _update() {
		while(SDL.pollEvent(_event) != 0) {
			switch(_event.ref.type) {
				case WINDOWEVENT:
					switch(_event.ref.window.event) {
						case CLOSE:
							_running = false;

						default: // fuckayou
					}
				
                default: // shut
			}
		}


    }
    
	// i'm gonna get wtaer
	// cock
	// balls
	// they exist
	// watch out
	private function renderTexture(id:Int) {
		Glad.activeTexture(Glad.TEXTURE0);
		Glad.bindTexture(Glad.TEXTURE_2D, id);


	}

    private var _nativeWindow:NativeWindow;
    private var _running:Bool = true;
    private var _event:Event;

	private var _glContext:GlContext;
	private var _VAO:cpp.UInt32;
	private var _VBO:cpp.UInt32;
	private var _EBO:cpp.UInt32;

	private var _projection:Matrix4x4;
	private var _defaultShader:Shader;
}
#else
class Window {
	public function new() {}
}
#end