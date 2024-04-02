function draw_sprite_margin(sprite,subimg,x1,y1,x2,y2,scale_margin){
	var color=draw_get_color(),alpha=draw_get_alpha();
	var sw=sprite_get_width(sprite)
	var sh=sprite_get_height(sprite)
	scale_margin=sw*scale_margin
	var hs=(x2-x1-scale_margin*2)/(sw-scale_margin*2)
	var vs=(y2-y1-scale_margin*2)/(sh-scale_margin*2)
	draw_sprite_part_ext(sprite,subimg,0,0,scale_margin,scale_margin,x1,y1,1,1,color,alpha)	//top left
	draw_sprite_part_ext(sprite,subimg,scale_margin,0,sw-scale_margin*2,scale_margin,x1+scale_margin,y1,hs,1,color,alpha)
	draw_sprite_part_ext(sprite,subimg,sw-scale_margin,0,scale_margin,scale_margin,x2-scale_margin,y1,1,1,color,alpha)
	draw_sprite_part_ext(sprite,subimg,0,scale_margin,scale_margin,sh-scale_margin*2,x1,y1+scale_margin,1,vs,color,alpha)
	draw_sprite_part_ext(sprite,subimg,scale_margin,scale_margin,sw-scale_margin*2,sh-scale_margin*2,x1+scale_margin,y1+scale_margin,hs,vs,color,alpha)
	draw_sprite_part_ext(sprite,subimg,sw-scale_margin,scale_margin,scale_margin,sh-scale_margin*2,x2-scale_margin,y1+scale_margin,1,vs,color,alpha)
	draw_sprite_part_ext(sprite,subimg,0,sh-scale_margin,scale_margin,scale_margin,x1,y2-scale_margin,1,1,color,alpha)
	draw_sprite_part_ext(sprite,subimg,scale_margin,sh-scale_margin,sw-scale_margin*2,scale_margin,x1+scale_margin,y2-scale_margin,hs,1,color,alpha)
	draw_sprite_part_ext(sprite,subimg,sw-scale_margin,sh-scale_margin,scale_margin,scale_margin,x2-scale_margin,y2-scale_margin,1,1,color,alpha)
}

function draw_sprite_margin_ext(sprite,subimg,x1,y1,x2,y2,scale_margin,scale,color,alpha){
	var sw=sprite_get_width(sprite)
	var sh=sprite_get_height(sprite)
	scale_margin=sw*scale_margin
	var hs=(x2-x1-scale_margin*2*scale)/(sw-scale_margin*2)
	var vs=(y2-y1-scale_margin*2*scale)/(sh-scale_margin*2)
	draw_sprite_part_ext(sprite,subimg,0,0,scale_margin,scale_margin,x1,y1,scale,scale,color,alpha)	//top left
	draw_sprite_part_ext(sprite,subimg,scale_margin,0,sw-scale_margin*2,scale_margin,x1+scale_margin*scale,y1,hs,scale,color,alpha)	//top
	draw_sprite_part_ext(sprite,subimg,sw-scale_margin,0,scale_margin,scale_margin,x2-scale_margin*scale,y1,scale,scale,color,alpha)	// top right
	draw_sprite_part_ext(sprite,subimg,0,scale_margin,scale_margin,sh-scale_margin*2,x1,y1+scale_margin*scale,scale,vs,color,alpha)	// left
	draw_sprite_part_ext(sprite,subimg,scale_margin,scale_margin,sw-scale_margin*2,sh-scale_margin*2,x1+scale_margin*scale,y1+scale_margin*scale,hs,vs,color,alpha)	// center
	draw_sprite_part_ext(sprite,subimg,sw-scale_margin,scale_margin,scale_margin,sh-scale_margin*2,x2-scale_margin*scale,y1+scale_margin*scale,scale,vs,color,alpha)	// right
	draw_sprite_part_ext(sprite,subimg,0,sh-scale_margin,scale_margin,scale_margin,x1,y2-scale_margin*scale,scale,scale,color,alpha)	// bottom left
	draw_sprite_part_ext(sprite,subimg,scale_margin,sh-scale_margin,sw-scale_margin*2,scale_margin,x1+scale_margin*scale,y2-scale_margin*scale,hs,scale,color,alpha)	// bottom
	draw_sprite_part_ext(sprite,subimg,sw-scale_margin,sh-scale_margin,scale_margin,scale_margin,x2-scale_margin*scale,y2-scale_margin*scale,scale,scale,color,alpha)	//bottom right
}

function draw_sprite_part_transform(sprite, index, left, top, width, height, centerx, centery, x, y, xscale, yscale, rot, col, alpha)
{
	var M = matrix_build(x,y,0, 0,0,rot, 1,1,1);
	var m = matrix_get(matrix_world);
	matrix_set(matrix_world, M);
	draw_sprite_part_ext(sprite, index, left, top, width, height, -centerx*xscale, -centery*yscale, xscale, yscale, col, alpha)
	matrix_set(matrix_world, m);
}

function draw_sprite_fit(sprite, index, x, y, width, height, color=c_white, alpha=1)
{
	// Scale sprite to fix within box
	var w=sprite_get_width(sprite);
	var h=sprite_get_height(sprite);
	var scale = min(width/w, height/h)
	draw_sprite_stretched_ext(sprite, index,
	x + width/2 - w*scale/2,	y + height/2 - h*scale/2,
	w*scale,	h*scale, color, alpha
	)
}

function draw_sprite_crop(sprite, index, x, y, width, height, color=c_white, alpha=1)
{
	var w=sprite_get_width(sprite);
	var h=sprite_get_height(sprite);
	var scale = max(width/w, height/h)
	var ratio = width/height;
	var sratio = w/h;
	var crop = ratio/sratio;
	var cw=w, ch=h;
	if crop<1 cw=w*crop else ch=h/crop;
	draw_sprite_part_ext(sprite, index,
	w/2-cw/2, h/2-ch/2,
	cw, ch,
	x, y, scale, scale, color, alpha
	)
	
	
}

function draw_isosceles_triangle(x1,y1,x2,y2,radius,outline) {
	var a=point_direction(x1,y1,x2,y2)
	var xl=x1+lengthdir_x(radius,a-90)
	var yl=y1+lengthdir_y(radius,a-90)
	var xr=x1+lengthdir_x(radius,a+90)
	var yr=y1+lengthdir_y(radius,a+90)
	draw_triangle(xl,yl,xr,yr,x2,y2,outline)
}

function draw_pie(x1,y1,x2,y2,x3,y3,x4,y4,outline,precision=24) {
    //
    //  Draws a sector of an elliptical disc, mimicking draw_pie() from GM5.
    //  It also mimics draw_ellipse() from GM6 in that it will draw either as a
    //  solid or an outline, and it uses a primitive drawn at a limited resolution.
    //  The pie is a closed figure of an arc with two lines between the center
    //  and the starting and ending points. The arc is drawn following the perimeter
    //  of the ellipse, counterclockwise, from the starting point to the ending
    //  point. The starting point is the intersection of the ellipse and the line
    //  from the center to (x3,y3). Then ending point is the intersection of the 
    //  ellipse and the line form the center to (x4,y4).
    //
    //      x1,y1       1st corner of bounding rectangle, real
    //      x2,y2       2nd corner of bounding rectangle, real
    //      x3,y3       determines the start angle, real
    //      x4,y4       determines the end angle, real
    //      outline     true to draw as an outline, bool
    //      precision   number of segments a full ellipse would be drawn with,
    //                  [4..64] divisible by 4, default 24, real (optional)
    //
    /// GMLscripts.com/license
        var res,xm,ym,xr,yr,r,a1,a2,sx,sy,a;
        res = 360 / min(max(4,4*(precision div 4)),64);
        xm = (x1+x2)/2;
        ym = (y1+y2)/2;
        xr = abs(x2-x1)/2;
        yr = abs(y2-y1)/2;
        if (xr > 0) r = yr/xr;
        else r = 0;
        a1 = point_direction(0,0,(x3-xm)*r,y3-ym);
        a2 = point_direction(0,0,(x4-xm)*r,y4-ym);
        if (a2<a1) a2 += 360;
        if (outline) draw_primitive_begin(pr_linestrip);
        else draw_primitive_begin(pr_trianglefan);
        draw_vertex(xm,ym);
        sx = xm+lengthdir_x(xr,a1);
        sy = ym+lengthdir_y(yr,a1);
        draw_vertex(sx,sy);
        for (a=res*(a1 div res + 1); a<a2; a+=res) {
            sx = xm+lengthdir_x(xr,a);
            sy = ym+lengthdir_y(yr,a);
            draw_vertex(sx,sy);
        }
        sx = xm+lengthdir_x(xr,a2);
        sy = ym+lengthdir_y(yr,a2);
        draw_vertex(sx,sy);
        if (outline) draw_vertex(xm,ym);
        draw_primitive_end();
        return 0;
}

function draw_arc(x1,y1,x2,y2,x3,y3,x4,y4,precision=24) {
    //
    //  Draws an arc of an ellipse mimicking draw_arc() from GM5. It also mimics
    //  draw_ellipse() from GM6 in that it uses a primitive drawn with limited
    //  resolution. The arc is drawn following the perimeter of the ellipse, 
    //  counterclockwise, from the starting point to the ending point.
    //  The starting point is the intersection of the ellipse with the ray 
    //  extending from the center point and passing through the point (x3,y3).
    //  The ending point is the intersection of the ellipse with the ray
    //  extending from the center through the point (x4,y4).
    //
    //      x1,y1       1st corner of bounding rectangle, real
    //      x2,y2       2nd corner of bounding rectangle, real
    //      x3,y3       determines starting point, real
    //      x4,y4       determines ending point, real
    //      precision   number of segments a full ellipse would be drawn with,
    //                  [4..64] divisible by 4, default 24, real (optional)
    //
    /// GMLscripts.com/license
        var res,xm,ym,xr,yr,r,a1,a2,sx,sy,a;
        res = 360 / min(max(4,4*(precision div 4)),64);
        xm = (x1+x2)/2;
        ym = (y1+y2)/2;
        xr = abs(x2-x1)/2;
        yr = abs(y2-y1)/2;
        if (xr > 0) r = yr/xr;
        else r = 0;
        a1 = point_direction(0,0,(x3-xm)*r,y3-ym);
        a2 = point_direction(0,0,(x4-xm)*r,y4-ym);
        if (a2<a1) a2 += 360;
        draw_primitive_begin(pr_linestrip);
        sx = xm+lengthdir_x(xr,a1);
        sy = ym+lengthdir_y(yr,a1);
        draw_vertex(sx,sy);
        for (a=res*(a1 div res + 1); a<a2; a+=res) {
            sx = xm+lengthdir_x(xr,a);
            sy = ym+lengthdir_y(yr,a);
            draw_vertex(sx,sy);
        }
        sx = xm+lengthdir_x(xr,a2);
        sy = ym+lengthdir_y(yr,a2);
        draw_vertex(sx,sy);
        draw_primitive_end();
        return 0;
    }
	
function draw_sprite_positions(sprite, index, x1, y1, x2, y2, x3, y3, x4, y4, color, alpha) {
	var col = draw_get_color();
	var alp = draw_get_alpha();
	draw_set_color(color);
	draw_set_alpha(alpha);
	draw_primitive_begin_texture(pr_trianglelist, sprite_get_texture(sprite, index))
	draw_vertex_texture(x1, y1, 0, 0);
	draw_vertex_texture(x2, y2, 1, 0);
	draw_vertex_texture(x4, y4, 0, 1);
	
	draw_vertex_texture(x2, y2, 1, 0);
	draw_vertex_texture(x3, y3, 1, 1);
	draw_vertex_texture(x4, y4, 0, 1);
	draw_primitive_end();
	draw_set_color(col);
	draw_set_color(alp);
	
}
	
function draw_3d_end() {matrix_set(matrix_world, matrix_build_identity());}

function draw_sprite_transformed(sprite,index,x1,y1,x2,y2,x3,y3,x4,y4) {
	draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(sprite,index))
	draw_vertex_texture(x1,y1,0,0)
	draw_vertex_texture(x2,y2,1,0)
	draw_vertex_texture(x3,y3,0,1)
	draw_vertex_texture(x4,y4,1,1)
	draw_primitive_end();
}

function draw_sprite_curved(sprite,index,x,y,angle,rot,xscale,yscale,color,alpha,precision=2) {
	draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(sprite,index))
	var x1,y1,u
	var width=sprite_get_width(sprite)*xscale
	var height=sprite_get_height(sprite)*yscale
	for(var i=0;i<=precision;i++) {
		u=InvLerp(0,precision,i)
		
		x1=x+lengthdir_x(width/2,angle-90)
		y1=y+lengthdir_y(width/2,angle-90)
		draw_vertex_texture_colour(x1,y1,0,u,color,alpha)
		
		x1=x+lengthdir_x(width/2,angle+90)
		y1=y+lengthdir_y(width/2,angle+90)
		draw_vertex_texture_colour(x1,y1,1,u,color,alpha)
		
		angle-=rot/precision
		x+=lengthdir_x(height/precision, angle)
		y+=lengthdir_y(height/precision, angle)
	}
	draw_primitive_end();
}

function draw_sprite_curved_ext(sprite,index,x1,y1,x2,y2,x3,y3,xscale,yscale,color,alpha,precision=3) {
	var angle1=point_direction(x1,y1,x2,y2)
	var angle2=-angle_difference(angle1,point_direction(x2,y2,x3,y3))
	var width=sprite_get_width(sprite)*xscale
	var height=sprite_get_height(sprite)*yscale
	
	var len=point_distance(x1,y1,x3,y3)
	var r=height/len
	x2=x1+(x2-x1)*r
	y2=y1+(y2-y1)*r
	x3=x1+(x3-x1)*r
	y3=y1+(y3-y1)*r
	
	var xx,yy,u,angle=angle1,xp,yp
	draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(sprite,index))
	for(var i=0;i<=precision;i++) {
		u=InvLerp(0,precision,i)
		
		var temp=curve_three_point(x1,y1,x2,y2,x3,y3,u)
		xx=temp[0]
		yy=temp[1]
		
		xp=xx+lengthdir_x(width/2,angle-90)
		yp=yy+lengthdir_y(width/2,angle-90)
		draw_vertex_texture_colour(xp,yp,0,u,color,alpha)
		
		xp=xx+lengthdir_x(width/2,angle+90)
		yp=yy+lengthdir_y(width/2,angle+90)
		draw_vertex_texture_colour(xp,yp,1,u,color,alpha)
		
		angle+=(angle2/precision)
		
	}
	draw_primitive_end();
}

function draw_texture_part_ext(texture,left,top,width,height,x,y,xscale,yscale,col,alpha) {
	draw_primitive_begin_texture(pr_trianglestrip, texture)
	var u=texture_get_width(texture)
	var v=texture_get_height(texture)
	var uv=array_create(4)
	uv[0] = InvLerp(0,u,left)
	uv[1] = InvLerp(0,v,top)
	uv[2] = InvLerp(0,u,left+width)
	uv[3] = InvLerp(0,v,top+height)
	
	draw_vertex_texture_colour(x,y,		uv[0],uv[1],col,alpha)
	draw_vertex_texture_colour(x+width*xscale,y,		uv[2],uv[1],col,alpha)
	draw_vertex_texture_colour(x,y+height*yscale,		uv[0],uv[3],col,alpha)
	
	draw_vertex_texture_colour(x+width*xscale,y,		uv[2],uv[1],col,alpha)
	draw_vertex_texture_colour(x+width*xscale,y+height*yscale,		1,uv[3],col,alpha)
	draw_vertex_texture_colour(x,y+height*yscale,		uv[0],uv[3],col,alpha)
	
	draw_primitive_end();
}

function draw_texture_ext(texture,x,y,xscale,yscale,col,alpha) {
	var width=texture_get_texel_width(texture)
	var height=texture_get_texel_height(texture)
	draw_primitive_begin_texture(pr_trianglestrip, texture)
	
	draw_vertex_texture_colour(x,y,		0,0,col,alpha)
	draw_vertex_texture_colour(x+width*xscale,y,		1,0,col,alpha)
	draw_vertex_texture_colour(x,y+height*yscale,		0,1,col,alpha)
	
	draw_vertex_texture_colour(x+width*xscale,y,		1,0,col,alpha)
	draw_vertex_texture_colour(x+width*xscale,y+height*yscale,		1,1,col,alpha)
	draw_vertex_texture_colour(x,y+height*yscale,		0,1,col,alpha)
	
	draw_primitive_end();
}
	
function draw_debug_surface(surface, x, y, width, height, scale,color,alpha) {
	var mpx = InvLerp(x, x+width, clamp(main.mousex, x, x+width));
	var mpy = InvLerp(y, y+height, clamp(main.mousey, y, y+height));
	mpx = clamp(mpx*1.5-0.25, 0, 1)
	mpy = clamp(mpy*1.5-0.25, 0, 1)
	var w = surface_get_width(surface);
	var h = surface_get_height(surface);
	var ratio = width/height;
	var size = min(h*ratio, w/ratio);
	if point_in_rectangle(main.mousex, main.mousey, x,y, x+width, y+height)
	{
		size /= scale
		var uvx = (w-size*ratio)*mpx;
		var uvy = (h-size)*mpy;
	} else {
		uvx = 0;
		uvy = 0;
	}

	draw_surface_part_ext(surface, uvx,uvy, size*ratio, size, x,y, width/(size*ratio),height/size,color,alpha);
}

function set_directional_light(from, to, up) {
	var X=0,Y=1,Z=2;
	with (renderer)
	{
		lightPosition[@ X] = from[X];
		lightPosition[@ Y] = from[Y];
		lightPosition[@ Z] = from[Z];
		lightForward[@ X]  = to[X] - from[X];
		lightForward[@ Y]  = to[Y] - from[Y];
		lightForward[@ Z]  = to[Z] - from[Z];
		lightTo[@X] = to[X]
		lightTo[@Y] = to[Y]
		lightTo[@Z] = to[Z]
		lightUp[@ X]       = up[X];
		lightUp[@ Y]       = up[Y];
		lightUp[@ Z]       = up[Z];
		
		normalize(lightForward);
		cross_product(lightForward, lightUp, lightRight);

		normalize(lightRight);
		cross_product(lightRight, lightForward, lightUp);
	
		lightViewMat = matrix_build_lookat(
			from[X], from[Y], from[Z],
			to[X],   to[Y],   to[Z],
			up[X],   up[Y],   up[Z]);
		lightProjMat = matrix_build_projection_ortho(-light_size, light_size, 0, light_dist);
	}
}
