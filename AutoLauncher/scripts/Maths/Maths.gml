function from_closer_to(from,to,divider) {
   gml_pragma("forceinline");
	return(from-((from-to)/divider))
}
function from_closer_to_angle(from,to,divider) {
   gml_pragma("forceinline");
	return(from-(angle_difference(from,to)/divider))
}
function from_closer_to_angle_clamp(from,to,divider,limit) {
   gml_pragma("forceinline");
	return(from-clamp(angle_difference(from,to)/divider,-limit,limit))
}
	
function lerp_curve(val1, val2, amount, factor)
{
	return lerp(val1, val2, power(amount, factor))
}

function from_closer_to_clamp(from,to,divider,limit) {
   gml_pragma("forceinline");
	return(from-clamp((from-to)/divider,-limit,limit))
}

function perlin_noise(_x, _y = 100.213, _z = 450.4215) {
	// https://github.com/samspadegamedev/YouTube-Perlin-Noise-Public
	#region //doubled perm table
	static _p = [
		151,160,137,91,90,15,
		131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
		190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
		88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
		77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
		102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
		135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
		5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
		223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
		129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
		251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
		49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
		138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180,
		151,160,137,91,90,15,
		131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
		190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
		88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
		77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
		102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
		135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
		5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
		223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
		129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
		251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
		49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
		138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
	];
	#endregion

    static _fade = function(_t) {
        return _t * _t * _t * (_t * (_t * 6 - 15) + 10);
    }

	static _lerp = function(_t, _a, _b) { 
		return _a + _t * (_b - _a); 
	}

    static _grad = function(_hash, _x, _y, _z) {
        var _h, _u, _v;
        _h = _hash & 15;                       // CONVERT 4 BITS OF HASH CODE
        _u = (_h < 8) ? _x : _y;                 // INTO 12 GRADIENT DIRECTIONS.
        if (_h < 4) {
            _v = _y;
        } else if ((_h == 12) || (_h == 14)) {
            _v = _x;
        } else {
            _v = _z;
        }
		if ((_h & 1) != 0) {
			_u = -_u;
		}
		if ((_h & 2) != 0) {
			_v = -_v;
		}		
        return _u + _v;
    }

    var _X, _Y, _Z;
    _X = floor(_x);
    _Y = floor(_y);
    _Z = floor(_z);
    
    _x -= _X;
    _y -= _Y;
    _z -= _Z;
    
    _X = _X & 255;
    _Y = _Y & 255;
    _Z = _Z & 255;
    
    var _u, _v, _w;
    _u = _fade(_x);
    _v = _fade(_y);
    _w = _fade(_z);
    
    var A, AA, AB, B, BA, BB;
    A  = _p[_X]+_Y;
    AA = _p[A]+_Z;
    AB = _p[A+1]+_Z;
    B  = _p[_X+1]+_Y;
    BA = _p[B]+_Z;
    BB = _p[B+1]+_Z;

	//returns a number between -1 and 1
    return _lerp(_w, _lerp(_v, _lerp(_u,_grad(_p[AA  ], _x  , _y  , _z   ),  // AND ADD
										_grad(_p[BA  ], _x-1, _y  , _z   )), // BLENDED
                             _lerp(_u,	_grad(_p[AB  ], _x  , _y-1, _z   ),  // RESULTS
										_grad(_p[BB  ], _x-1, _y-1, _z   ))),// FROM  8
                    _lerp(_v, _lerp(_u,	_grad(_p[AA+1], _x  , _y  , _z-1 ),  // CORNERS
										_grad(_p[BA+1], _x-1, _y  , _z-1 )), // OF CUBE
                             _lerp(_u,	_grad(_p[AB+1], _x  , _y-1, _z-1 ),
										_grad(_p[BB+1], _x-1, _y-1, _z-1 )))); 

}

function point_direction_3d(x1,y1,z1,x2,y2,z2) {
   gml_pragma("forceinline");
	var length=point_distance_3d(x1,y1,z1,x2,y2,z2);
	if length=0 return [0,0]
	var normal_z=(z2-z1)/length;
	var yaw=point_direction(x1,y1,x2,y2)
	var pitch=darcsin(normal_z);
	
	if yaw<0 yaw += 360;
	if pitch<0 pitch += 360;
	return[yaw,pitch];
}

function lengthdir_x_3d(length,yaw,pitch) {
	return lengthdir_x(lengthdir_x(length, yaw), pitch);
}

function lengthdir_y_3d(length,yaw,pitch) {
	return lengthdir_x(lengthdir_y(length, yaw), pitch);
}

function lengthdir_z_3d(length,pitch) {
	return length * dtan(pitch);
}

function wrap(value,val1,val2) {
	//	WRAP VALUE INSIDE RANGE.
	return (((value - val1) % (val2 - val1)) + (val2 - val1)) % (val2 - val1) + val1;
}
function array_wrap(array, index)//untested
{
	//	Access array value, index are wrapped within array length
	var s=array_length(array);
	var i=wrap(index, 0, s);
	return array[@i]
}

function array_offset(array, amount)
{
	var s = array_length(array);
	var temp=array_create(s);
	array_copy(temp, 0, array, 0, s);
	var ind=-amount;
	while ind<0 ind+=s;
	while ind>s ind-=s;
	for(var i=0;i<s;i++)
	{
		array[@i] = temp[ind];
		ind++;
		if ind>=s ind=0		
	}
}

function lengthdir_3d(length,yaw,pitch) {
	var _x = lengthdir_x(lengthdir_x(length, yaw), pitch);
	var _y = lengthdir_x(lengthdir_y(length, yaw), pitch);
	var _z = length * dtan(pitch)
	return [_x,_y,_z]
	
offset_x = lengthdir_x(lengthdir_x(length, direction_xy), direction_z);
offset_y = lengthdir_x(lengthdir_y(length, direction_xy), direction_z);
offset_z = lengthdir_y(length, direction_z);
}

function lengthdir_3d_roll(x,y,z,yaw,pitch,roll) {
	yaw=degtorad(yaw)
	pitch=degtorad(pitch)
	roll=degtorad(roll)
	var x1 = x*(cos(yaw)*cos(pitch))  + y*(cos(yaw)*sin(pitch)*sin(roll)+sin(yaw)*cos(roll))  + z*(cos(yaw)*-sin(pitch)*cos(roll)+sin(yaw)*sin(roll));
	var y1 = x*(-sin(yaw)*cos(pitch)) + y*(-sin(yaw)*sin(pitch)*sin(roll)+cos(yaw)*cos(roll)) + z*(-sin(yaw)*-sin(pitch)*cos(roll)+cos(yaw)*sin(roll));
	var z1 = x*(sin(pitch))     + y*(cos(pitch)*-sin(roll))          + z*(cos(pitch)*cos(roll));
	
	return [x1,y1,z1]
}

function InvLerp( val1, val2, value ) {
   gml_pragma("forceinline");
	//find the percentage that equates to the position between two other values for a given value. 
	return (value-val1)/(val2-val1)
}

function calculate_wall_normal(x1,y1,x2,y2) {
	var xdiff = x2 - x1;
	var ydiff = y2 - y1;
	
	var squared = (xdiff * xdiff) + (ydiff * ydiff);
	if squared == 0 return false
	var l = sqrt(squared);
	
	var nx = ydiff / l;
	var ny = -xdiff / l;
	
	return [nx, ny, 0];
}

function vertex_buffer_add(vbuffer,x,y,z,nx,ny,nz,u,v,color,alpha) {
	vertex_position_3d(vbuffer, x, y, z);
	vertex_normal(vbuffer, nx, ny, nz);
	vertex_texcoord(vbuffer, u, v);
	vertex_colour(vbuffer, color, alpha);
}
	
function vertex_buffer_add_buffer(vbuffer, mbuffer, matrix, uvs, alpha) {
	// Add model buffer to vertex buffer, assuming model is in standard format
	var vp, vn, vc, size, vertex, u, v;
	if is_undefined(matrix) matrix=matrix_build_identity();
	size = buffer_get_size(mbuffer) / mBuffStdBytesPerVert;
	for(var i=0; i<size; i++)
	{
		vertex = mbuff_read_vertex(mbuffer, i);
		vp = matrix_transform_vertex(matrix, vertex[0], vertex[1], vertex[2], 1.);
		vn = matrix_transform_vertex(matrix, vertex[3], vertex[4], vertex[5], 0.);
		vc = make_color_rgb(vertex[8], vertex[9], vertex[10]);
		if is_undefined(alpha) alpha=vertex[11];
		if is_undefined(uvs)
		{
			u = vertex[6]; v = vertex[7];
		} else {
	  		u = lerp(uvs[0], uvs[2], vertex[6])
			v = lerp(uvs[1], uvs[3], vertex[7])
		}
		vertex_buffer_add(vbuffer, vp[0],vp[1],vp[2],	vn[0],vn[1],vn[2],	u,v,	vc, alpha)
	}
}

function matrix_transform_pos(matrix) {
		var _x = matrix[12];
		var _y = matrix[13];
		var _z = matrix[14];
	return [_x,_y,_z]
}

function matrix_view_pos(view_mat) {
var _x = -view_mat[0] * view_mat[12] - view_mat[1] * view_mat[13] - view_mat[2] * view_mat[14]; 
var _y = -view_mat[4] * view_mat[12] - view_mat[5] * view_mat[13] - view_mat[6] * view_mat[14];
var _z = -view_mat[8] * view_mat[12] - view_mat[9] * view_mat[13] - view_mat[10] * view_mat[14];
return [_x,_y,_z]
}

function angle_difference_3d(x1,y1,z1,x2,y2,z2) {
	var a=(x1 * x2 + y1 * y2 + z1 * z2)
	var b=(sqrt(power(x1,2) + power(y1,2) + power(z1,2)) * sqrt(power(x2,2) + power(y2,2) + power(z2,2)))
	return radtodeg(arccos(a/b))
}

function vector_angle_difference(v1,v2) {
	var a=(v1[0] * v2[0] + v1[1] * v2[1] + v1[2] * v2[2])
	var b=(sqrt(power(v1[0],2) + power(v1[1],2) + power(v1[2],2)) * sqrt(power(v2[0],2) + power(v2[1],2) + power(v2[2],2)))
	return radtodeg(arccos(a/b))
}

function vector_create(x1,y1,z1,x2,y2,z2) {
	return [x2-x1,y2-y1,z2-z1]
}

function pointInRotatedRectangle(pointX, pointY,
    rectX, rectY, rectOffsetX, rectOffsetY, rectWidth, rectHeight, rectAngle
) {
    var relX = pointX - rectX;
    var relY = pointY - rectY;
    var angle = -rectAngle;
    var angleCos = Math.cos(angle);
    var angleSin = Math.sin(angle);
    var localX = angleCos * relX - angleSin * relY;
    var localY = angleSin * relX + angleCos * relY;
    return localX >= -rectOffsetX && localX <= rectWidth - rectOffsetX &&
           localY >= -rectOffsetY && localY <= rectHeight - rectOffsetY;
}

function curve_three_point(x1,y1,x2,y2,x3,y3,step) {
	// step:rangle from 0 to 1
	// return array of [x,y] position
	
	x1=lerp(x1,x2,step)
	y1=lerp(y1,y2,step)
	
	x2=lerp(x2,x3,step)
	y2=lerp(y2,y3,step)
	
	return [lerp(x1,x2,step),lerp(y1,y2,step)]
}

function curve_three_point_length(x1,y1,x2,y2,x3,y3,precision) {
	// step:rangle from 0 to 1
	// return array of [x,y] position
	var step,total=0,xx,yy,lx=x1,ly=y1
	for(var i=0;i<=precision;i++) {
		step=InvLerp(0,precision,i)
		x1=lerp(x1,x2,step)
		y1=lerp(y1,y2,step)
	
		x2=lerp(x2,x3,step)
		y2=lerp(y2,y3,step)
	
		xx=lerp(x1,x2,step)
		yy=lerp(y1,y2,step)
		total+=point_distance(lx,ly,xx,yy)
		lx=xx;
		ly=yy;
	}
	return total
}

function snap_to_grid(value, scale) {return floor(value/scale)*scale}

function matrix_build_transform(x,y,z,xrot,yrot,zrot,xscale,yscale,zscale) {
	var s=matrix_build( 0,0,0,0,0,0,xscale,yscale,zscale)
	var p=matrix_build( x,y,z,xrot,yrot,zrot,1,1,1)
	return matrix_multiply(s,p)
}

function lengthdir_vector(vx,vy,vz,len) {
	var v=smf_vector_normalize([vx,vy,vz])
	return [v[0]*len,v[1]*len,v[2]*len]
}

function sprite_get_tile_uv(sprite,index,left,top,width,height) {
	var spr_uv=sprite_get_uvs(sprite, index);
	var uv=array_create(4);
	var w=sprite_get_width(sprite)
	var h=sprite_get_height(sprite)
	uv[@0]=lerp(spr_uv[0],spr_uv[2],left/w);
	uv[@2]=lerp(spr_uv[0],spr_uv[2],(left+width)/w);
	uv[@1]=lerp(spr_uv[1],spr_uv[3],top/h);
	uv[@3]=lerp(spr_uv[1],spr_uv[3],(top+height)/h);
	return uv;
}

function texture_get_tile_uv(texture, left, top, width, height)
{
	var spr_uv=texture_get_uvs(texture);
	var uv=array_create(4);
	var w=1/texture_get_texel_width(texture)
	var h=1/texture_get_texel_height(texture)
	uv[@0]=lerp(spr_uv[0],spr_uv[2],left/w);
	uv[@2]=lerp(spr_uv[0],spr_uv[2],(left+width)/w);
	uv[@1]=lerp(spr_uv[1],spr_uv[3],top/h);
	uv[@3]=lerp(spr_uv[1],spr_uv[3],(top+height)/h);
	return uv;
}

/*
function tile_uv(tile_width, tile_height, left, top, width, height) {
	var uv=array_create(4);
	var w=tile_width;
	var h=tile_height;
	uv[@0]=left/w;
	uv[@2]=(left+width)/w;
	uv[@1]=top/h;
	uv[@3]=(top+height)/h;
	return uv;
}
*/

///@func cross_product(a, b, result)
function cross_product(x1, y1, z1, x2, y2, z2, result=undefined)
{
	if is_array(x1)
	{
	var X=0,Y=1,Z=2,output=z1;
	var ax = x1[X], ay = x1[Y], az = x1[Z],
		bx = y1[X], by = y1[Y], bz = y1[Z];
	} else {
		output = result;
		var ax = x1, ay = y1, az = z1,
			bx = x2, by = y2, bz = z2;
	}
	if is_undefined(output)
	{
		return [ay * bz - az * by, az * bx - ax * bz, ax * by - ay * bx]
	}
	output[@X] = ay * bz - az * by;
	output[@Y] = az * bx - ax * bz;
	output[@Z] = ax * by - ay * bx;
}
/*
function cross_product(a, b, result) {
	var X=0,Y=1,Z=2;
	var ax = a[X], ay = a[Y], az = a[Z],
		bx = b[X], by = b[Y], bz = b[Z];
	result[@X] = ay * bz - az * by;
	result[@Y] = az * bx - ax * bz;
	result[@Z] = ax * by - ay * bx;
}
*/
function normalize(vec) {
	var vx,vy,vz,mag
	if is_array(vec) {vx = vec[0]; vy = vec[1]; vz = vec[2]} else {vx=argument[0]; vy=argument[1]; vz=argument[2]; vec=array_create(3)}
	mag = sqrt(vx*vx + vy*vy + vz*vz);
	vec[@0] = vx / mag;
	vec[@1] = vy / mag;
	vec[@2] = vz / mag;
	return vec;
}

function vector_length(vec)
{
	return point_distance_3d(0,0,0,vec[0], vec[1], vec[2])
}

/// @func convert_3d_to_2d(x,y,z,view_mat,proj_mat)
function convert_3d_to_2d(xx,yy,zz,view_mat,proj_mat) {
   gml_pragma("forceinline");
	if (proj_mat[15] == 0)
	{   //This is a perspective projection
	    var w = view_mat[2] * xx + view_mat[6] * yy + view_mat[10] * zz + view_mat[14];
	    // If you try to convert the camera's "from" position to screen space, you will
	    // end up dividing by zero (please don't do that)
	    //if (w <= 0) return [-1, -1];
	    if (w == 0) return [-1, -1];
	    var cx = proj_mat[8] + proj_mat[0] * (view_mat[0] * xx + view_mat[4] * yy + view_mat[8] * zz + view_mat[12]) / w;
	    var cy = proj_mat[9] + proj_mat[5] * (view_mat[1] * xx + view_mat[5] * yy + view_mat[9] * zz + view_mat[13]) / w;
			} else {    //This is an ortho projection
	    var cx = proj_mat[12] + proj_mat[0] * (view_mat[0] * xx + view_mat[4] * yy + view_mat[8]  * zz + view_mat[12]);
	    var cy = proj_mat[13] + proj_mat[5] * (view_mat[1] * xx + view_mat[5] * yy + view_mat[9]  * zz + view_mat[13]);
	}
	return [(0.5 + 0.5 * cx), (1 - (0.5 + 0.5 * cy))];
}

///@func ds_list_add_list(id, source...)
function ds_list_add_list(id,source) {
	var ds, s, di;
    for (var i = 1; i < argument_count; i ++)
    {
        ds = argument[i];
		s = ds_list_size(ds);
		for( di = 0; di < s; di++ ) ds_list_add(id,  ds[| di]);
    }
}

function point_in_sphere(px, py, pz, sx, sy, sz, rad) {
	if point_distance_3d(px, py, pz, sx, sy, sz) <= rad {return true}
	return false;
}

function point_in_cube(px, py, pz, x1, y1, z1, x2, y2 ,z2) {
	if point_in_rectangle(px, py, x1, y1, x2, y2) && pz>=min(z1,z2) && pz<=max(z1,z2) return true
	return false;
}

#region BUFFER GRID FUNC
function buffer_grid(type, w, h) constructor {
	self.type=type;
	width = w;
	height = h;
	sizeof=buffer_sizeof(type);
	if type=buffer_u8 {var b_type = buffer_fast} else {var b_type = buffer_fixed}
	data=buffer_create(w*h*sizeof, b_type, sizeof);
	if data=-1 {log("buffer grid create failed!", "error")}
	buffer_seek(data, buffer_seek_start, 0)
	return self;
	
	static set = function(x,y,value)
	{
		if x>=width || y>=height return false
		var i=width*y + x;
		buffer_poke(data, i*sizeof, type, value)
	}
	static get = function(x,y)
	{
		if x>=width || y>=height return undefined
		var i=width*y + x;
		return buffer_peek(data, i*sizeof, type)
	}
	static seek = function(x,y)
	{
		if x>=width || y>=height return false
		var i=width*y + x;
		buffer_seek(data, buffer_seek_start, i*sizeof)
		return true
	}
	static read = function()
	{
		return buffer_read(data, type);
	}
}

function buffer_grid_write(grid) {	// NOT TESTED
	with(grid)
	{
		var m=ds_map_create();
		m[? "type"]=type;
		m[? "scale"]=[width,height]
		m[? "size"]=sizeof;
		m[? "data"]=buffer_base64_encode(data, 0, sizeof);
		var temp=ds_map_write(m);
		ds_map_destroy(m)
		return temp;
	}
}

function buffer_grid_destroy(buff) {
	buffer_delete(buff.data)
	delete buff
}
function buffer_grid_get(buff, x, y) {return buff.get(x,y)}
function buffer_grid_set(buff, x, y, value) {return buff.set(x,y,value)}
function buffer_grid_width(buff) {return buff.width}
function buffer_grid_height(buff) {return buff.height}

function grid_to_buffer_grid(buff,grid) {
	var w=ds_grid_width(grid);
	var h=ds_grid_height(grid);
	buffer_grid_resize(buff, w, h);
	for(var xx=0;xx<w;xx++) {
	for(var yy=0;yy<h;yy++) {
		var v=grid[# xx,yy];
		if !is_real(v) {v=0;log("Warning, found string converting from grid to buffer","warning")}
		buffer_grid_set(buff, xx, yy, v);
	}}
	return true
}

function buffer_grid_to_grid(buff) {
	var w=buffer_grid_width(buff);
	var h=buffer_grid_height(buff);
	var temp=ds_grid_create(w,h);
	for(var xx=0;xx<w;xx++) {
	for(var yy=0;yy<h;yy++) {
		temp[# xx,yy]=buffer_grid_get(buff, xx, yy);
	}}
	return temp;
}

function buffer_grid_resize(buff, w, h) {
	if buff.type=buffer_u8 {var b_type = buffer_fast} else {var b_type = buffer_fixed}
	var temp=buffer_create(w*h*buff.sizeof, b_type, buff.sizeof);
	for(var yy=0;yy<h;yy++) {
	for(var xx=0;xx<w;xx++) {
		var v=0;
		if xx<buff.width && yy<buff.height
		{
			v=buff.get(xx,yy);
		}
		var i=w*yy + xx;
		buffer_poke(temp, i*buff.sizeof, buff.type, v);
	}}
	buffer_delete(buff.data);
	buff.data = temp;
	buff.width = w;
	buff.height = h;
}

function buffer_grid_set_grid_region(buff, source, x1, y1, x2, y2, xpos, ypos) {
	var data=source.data;
	if source==buff {
		if source.type=buffer_u8 {var b_type = buffer_fast} else {var b_type = buffer_fixed}
		var s=buffer_get_size(source.data);
		data=buffer_create(s, b_type, source.sizeof);
		buffer_copy(source.data, 0, s, data, 0);
		}
	
	var w=min(xpos+(x2-x1),buffer_grid_width(buff))
	var h=min(ypos+(y2-y1),buffer_grid_height(buff))
	var yi=y1,val;
	for(var yy=ypos;yy<h;yy++) {
	var xi=x1;
	for(var xx=xpos;xx<w;xx++) {
		
		if xi<source.width || yi<source.height
		{
			var i=source.width*yi + xi;
			val = buffer_peek(data, i*source.sizeof, source.type)
		} else {
			val=0
		}
		if is_undefined(val) val=0;
		//log("buffer_grid_set("+string(buff)+","+string(xx)+","+string(yy)+","+string(val))
		buffer_grid_set(buff, xx, yy, val);
		xi+=1;
	}
	yi+=1;
	}
	
	if source==buff buffer_delete(data);
}

function buffer_grid_copy(buff,source) {
	if source.type=buffer_u8 {var b_type = buffer_fast} else {var b_type = buffer_fixed}
	var s=buffer_get_size(source.data);
	var data=buffer_create(s, b_type, source.sizeof);
	buffer_copy(source.data, 0, s, data, 0);
	buffer_delete(buff.data)
	buff.data	= data
	buff.width	= source.width
	buff.height	= source.height
	buff.sizeof	= source.sizeof
	buff.type	= source.type
}
#endregion	

#region BUFFER LIST FUNC

function buffer_write_data(buffer, type, value)
{
	for (var i = 2; i < argument_count; i ++)
	{
		buffer_write(buffer, buffer_u8, type)
		buffer_write(buffer, type, argument[i])
	}
}

function buffer_write_buffer(dest, source)
{
	var size = buffer_get_size(source)
	buffer_write(buffer, buffer_u8, 255)
	buffer_write(buffer, buffer_u32, size)
	buffer_copy(source, 0, size, dest, buffer_tell(dest))
}

function buffer_read_data(buffer)
{
	var type=buffer_read(buffer, buffer_u8)
	switch(type)
	{
		default:
			return buffer_read(buffer, type)
			
		case 255:
			var size = buffer_read(buffer, buffer_u32);
			var temp = buffer_create(size, buffer_grow, 1);
			buffer_copy(buffer, buffer_tell(buffer), size, temp, 0);
			return temp;
	}
}

#endregion

#region BUFFER VOLUME FUNC
function buffer_volume(type, w, l, h) constructor {
	self.type=type;
	width = w;	// x
	length = l; // y
	height = h; // z
	sizeof=buffer_sizeof(type);
	if type=buffer_u8 {var b_type = buffer_fast} else {var b_type = buffer_fixed}
	data=buffer_create(l*w*h*sizeof, b_type, sizeof);
	if data=-1 {log("buffer volume create failed!", "error")}
	buffer_seek(data, buffer_seek_start, 0)
	return self;
	
	static set = function(x,y,z,value)
	{
		if x>=width || y>=length || z>=height return undefined
		var i = (x*height)+(y*width*height)+z;
		buffer_poke(data, i*sizeof, type, value)
	}
	static get = function(x,y,z)
	{
		if x>=width || y>=length || z>=height return undefined
		var i = (x*height)+(y*width*height)+z;
		return buffer_peek(data, i*sizeof, type)
	}
	static seek = function(x,y,z)
	{
		if x>=width || y>=length || z>=height return undefined
		var i = (x*height)+(y*width*height)+z;
		buffer_seek(data, buffer_seek_start, i*sizeof)
		return true
	}
	static read = function()
	{
		return buffer_read(data, type);
	}
	static destroy = function()
	{
		buffer_delete(data)
	}
}
#endregion

function array_multiply(array, value) {
	var s=array_length(array)
	for(var i=0;i<s;i++)
	{
		array[@i]*=value
	}
	return array;
}
function array_get_min(array) {
	var curr=undefined, val=infinity;
	var s=array_length(array)
	for(var i=0;i<s;i++)
	{
		if array[i]<val {curr = array[i]; val = curr}
	}
	return curr;
}
function array_lerp(array1, array2, amount, output)
{
	var s=array_length(array1)
	if is_undefined(output) output = array_create(s);
	for(var i=0;i<s;i++)
	{
		output[@i] = lerp(array1[i], array2[i], amount)
	}
	return output;
}
function array_get_mean(array) {
	var s=array_length(array),sum=0;
	for(var i=0;i<s;i++)
	{
		sum+=array[i]
	}
	return(sum/s);
}
///@func array_add(array, source...)
function array_add(array, source)
{
	var ds, s, di, l=array_length(array);
    for (var i = 1; i < argument_count; i ++)
    {
        ds = argument[i];
		for( di = 0; di < l; di++ ) array[@di] += ds[di];
    }
}

/*
function point_distance_line_3d(px, py, pz, x1, y1, z1, x2, y2, z2) {
  var line_dist = point_distance_3d(x1, y1, z1, x2, y2, z2);
  if (line_dist = 0) return point_distance_3d(px, py, pz, x1, y1, z1);
  var t = ((px - x1) * (x2 - x1) + (py - y1) * (y2 - y1) + (pz - z1) * (z2 - z1)) / line_dist;
  t = clamp(t, 0, 1);
  return point_distance_3d(px, py, pz, x1 + t * (x2 - x1), y1 + t * (y2 - y1), z1 + t * (z2 - z1));
}*/

function line_nearest_point_3d(x1,y1,z1, x2,y2,z2, px,py,pz, segment=true, array)
{
	// Find nearest point on a line.
	//	If an array is supplied, return new coordinate, otherwise return vector multiplier
	var dis = point_distance_3d(x1,y1,z1, x2,y2,z2);
	var dx = (x2 - x1)/dis;
	var dy = (y2 - y1)/dis;
	var dz = (z2 - z1)/dis;
	var d = dot_product_3d(px-x1, py-y1, pz-z1, dx,dy,dz);
	
	if segment
	{
		d/=dis;
		if d<0 {if is_undefined(array) {return 0} else {array[@0]=x1; array[@1]=y1; array[@2]=z1;return array}}
		if d>1 {if is_undefined(array) {return 1} else {array[@0]=x2; array[@1]=y2; array[@2]=z2;return array}}
		if is_undefined(array) return d;
		array[@0] = lerp(x1, x2, d);
		array[@1] = lerp(y1, y2, d);
		array[@2] = lerp(z1, z2, d);
		return array;
	}
	if is_undefined(array) {return d/dis} else 
	{
		array[@0] = x1 + dx*d;
		array[@1] = y1 + dy*d;
		array[@2] = z1 + dz*d;
		return array;
	}
}

function line_distance_point_3d(x1,y1,z1, x2,y2,z2, px,py,pz, segment=true)
{
	// Return nearest distance from point to line in 3D
	var dis = point_distance_3d(x1,y1,z1, x2,y2,z2);
	var dx = (x2 - x1)/dis;
	var dy = (y2 - y1)/dis;
	var dz = (z2 - z1)/dis;
	var d = dot_product_3d(px-x1, py-y1, pz-z1, dx,dy,dz);
	
	if segment
	{
		d/=dis;
		if d<0 {return point_distance_3d(px, py, pz, x1, y1, z1)}
		if d>1 {return point_distance_3d(px, py, pz, x2, y2, z2)}
		return point_distance_3d(px, py, pz, lerp(x1,x2,d), lerp(y1,y2,d), lerp(z1,z2,d))
	}
	return point_distance_3d(px, py, pz, x1+dx*d, y1+dy*d, z1+dz*d)
}

function line_nearest_point(x1, y1, x2, y2, px, py, segment = true)
{
	//	Find a point on a line that is nearest to a defined point
	// return vector multiplier
	var dir = point_direction(x1, y1, x2, y2);
	var dis = point_distance(x1, y1, x2, y2);
	var nx = lengthdir_x(1, dir), ny = lengthdir_y(1, dir);
	
	var lhx = px - x1, lhy = py - y1;
	
	if segment var d = clamp(dot_product(lhx, lhy, nx, ny),0,dis) / dis;
	else var d = dot_product(lhx, lhy, nx, ny) / dis;
	return d;
}

function line_distance_point(x1, y1, x2, y2, px, py, segment = true)
{
	var t = line_nearest_point(x1, y1, x2, y2, px, py, segment);
	return point_distance(lerp(x1,x2,t), lerp(y1,y2,t), px, py);
}

/// @func get_projectile_angle(x,y,targetx, targety, speed, gravity)
function get_projectile_angle(x, y, targetx, targety, s, g)
{
var xt = floor(targetx - x);
var yt = -floor(targety - y);
var root = power(s,4) - g*(g*sqr(xt) + 2*sqr(s)*yt);
var angle = 0;

if (root > 0) 
	{
	angle = radtodeg( arctan( (sqr(s) + sqrt( root ) ) / (g*xt) ));
	if (xt < 0) angle -= 180;
	}
else 
	{
	if (xt > 0)	angle = 45;
	else angle = 135;
	}

return angle;
}

function ds_grid_debug(ds_grid) {
	var h=ds_grid_height(ds_grid)
	var w=ds_grid_width(ds_grid)
	var str;
	for(var yy=0;yy<h;yy++)
	{	
		for(var xx=0;xx<w;xx++)
		{
			if xx=0 str = string(ds_grid[# xx,yy])
			else str=str+", "+string(ds_grid[# xx,yy])
		}
		show_debug_message(str)
	}

}

function reflect_vector(v1,v2)
{
	if array_length(v1)=3
	{
		var dot = dot_product_3d_normalized(v1[0], v1[1], v1[2], v2[1], v2[2], v2[3])
		v1[@0] = v1[0] - 2*dot*v2[0]
		v1[@1] = v1[1] - 2*dot*v2[1]
		v1[@2] = v1[2] - 2*dot*v2[2]
		return v1;
	} else {
		var dot = dot_product_normalized(v1[0], v1[1], v2[0], v2[1])
		v1[@0] = v1[0] - 2*dot*v2[0]
		v1[@1] = v1[1] - 2*dot*v2[1]
		return v1;
	}
}


function sphere_projection_radius(x,y,z,radius)
//	Return circle radius when project a sphere onto screen.
{
	var dis = point_distance_3d(x, y, z, renderer.xFrom, renderer.yFrom, renderer.zFrom);
	var r = arctan(radius/dis);
	r *= max(main.width, main.height) / degtorad(renderer.fov);
	return r;
}

function matrix_projection_aspect(projMat) {
	return projMat[5] / projMat[0];
}
/*
function matrix_get_angle(mat) {
	// return [roll, pitch, yaw] or [xrot, yrot, zrot]
	var yaw, pitch, roll;
        if (mat[0] == 1. || mat[0] == -1.)
        {
            yaw = arctan2(mat[2], mat[11]);
            pitch = 0;
            roll = 0;

        } else {
            yaw = arctan2(-mat[8],mat[0]);
			var s = wrap(mat[4], -1, 1)
            pitch = arcsin(s);
            roll = arctan2(-mat[6],mat[5]);
        }
	return [radtodeg(roll), radtodeg(pitch), radtodeg(yaw)]
}
*/
function matrix_get_angle(mat)
{
	var s=wrap(mat[9],-1, 1);
    var xrot = arcsin(-s);
    var yrot = arctan2(mat[8], mat[10]);
    var zrot = arctan2(mat[2], mat[5]);
	return [xrot, yrot, zrot]
}

function matrix_get_origin(mat)
{
	return [mat[12], mat[13], mat[14]]
}

function rotation_matrix_create(xrot, yrot, zrot) {
	// Create a rotation matrix based on Euler's angle
	// where [xrot, yrot, zrot] refer as [roll, pitch, yaw]
	// Useful if you only need angle transform without position
	//	https://danceswithcode.net/engineeringnotes/rotations_in_3d/rotations_in_3d_part2.html
	var yaw = degtorad(zrot);
	var pitch = degtorad(yrot);
	var roll = degtorad(xrot);
	var mat = array_create(9,0)
	var su = sin(roll);
    var cu = cos(roll);
    var sv = sin(pitch);
    var cv = cos(pitch);
    var sw = sin(yaw);
    var cw = cos(yaw);
        
        mat[0] = cv*cw;
        mat[1] = su*sv*cw - cu*sw;
        mat[2] = su*sw + cu*sv*cw;
        mat[3] = cv*sw;
        mat[4] = cu*cw + su*sv*sw;
        mat[5] = cu*sv*sw - su*cw;
        mat[6] = -sv;
        mat[7] = su*cv;
        mat[8] = cu*cv;         
        return mat;
	}
	
function rotation_matrix_get_angle(mat)
{
	// Return array containing [xrot, yrot, zrot]
	//	https://danceswithcode.net/engineeringnotes/rotations_in_3d/rotations_in_3d_part2.html
        var angle = array_create(3);
        angle[1] = -arcsin( mat[6] );  //Pitch

        //Gymbal lock: pitch = -90
        if( mat[6] == 1 ){    
            angle[0] = 0.0;             //yaw = 0
            angle[2] = arctan2( -mat[1], -mat[2] );    //Roll
        }
        //Gymbal lock: pitch = 90
        else if( mat[6] == -1 ){    
            angle[0] = 0.0;             //yaw = 0
            angle[2] = arctan2( mat[1], mat[2] );    //Roll
        }
        //General solution
        else{
            angle[0] = arctan2(  mat[3], mat[0] );
            angle[2] = arctan2(  mat[7], mat[8] );
        }
		//return angle;
		angle[0] = radtodeg(angle[0]);
		angle[1] = radtodeg(angle[1]);
		angle[2] = radtodeg(angle[2]);
        return [angle[2], angle[1], angle[0]];   //Euler angles in order roll, pitch, yaw
}

function rotation_matrix_inverse(mat)
{
	// Invert rotation matrix
	//	https://danceswithcode.net/engineeringnotes/rotations_in_3d/rotations_in_3d_part2.html
        var out = mat;
        out[0] = mat[0];
        out[1] = mat[3];
        out[2] = mat[6];
        out[3] = mat[1];
        out[4] = mat[4];
        out[5] = mat[7];
        out[6] = mat[2];
        out[7] = mat[5];
        out[8] = mat[8];
        return out;
}

function rotation_matrix_multiply(mat1, mat2)
{
	// multiply 2 rotation matrix
	//	https://danceswithcode.net/engineeringnotes/rotations_in_3d/rotations_in_3d_part2.html
	var mat = array_create(9)
        mat[0] = mat1[0]*mat2[0] + mat1[1]*mat2[3] + mat1[2]*mat2[6];
        mat[1] = mat1[0]*mat2[1] + mat1[1]*mat2[4] + mat1[2]*mat2[7];
        mat[2] = mat1[0]*mat2[2] + mat1[1]*mat2[5] + mat1[2]*mat2[8];
        mat[3] = mat1[3]*mat2[0] + mat1[4]*mat2[3] + mat1[5]*mat2[6];
        mat[4] = mat1[3]*mat2[1] + mat1[4]*mat2[4] + mat1[5]*mat2[7];
        mat[5] = mat1[3]*mat2[2] + mat1[4]*mat2[5] + mat1[5]*mat2[8];
        mat[6] = mat1[6]*mat2[0] + mat1[7]*mat2[3] + mat1[8]*mat2[6];
        mat[7] = mat1[6]*mat2[1] + mat1[7]*mat2[4] + mat1[8]*mat2[7];
        mat[8] = mat1[6]*mat2[2] + mat1[7]*mat2[5] + mat1[8]*mat2[8];
        return mat;   //Returns combined rotation (C=AB)
}

function rotation_matrix_vector(mat, x, y, z)
{
	// Rotate a 3d point to rotation matrix and return array containing new coordinate [x,y,z]
	//	https://danceswithcode.net/engineeringnotes/rotations_in_3d/rotations_in_3d_part2.html
        var out = array_create(3);
        out[0] = mat[0]*x + mat[1]*y + mat[2]*z;
        out[1] = mat[3]*x + mat[4]*y + mat[5]*z;
        out[2] = mat[6]*x + mat[7]*y + mat[8]*z;
        return out;
}

function convert_2d_to_3d(viewMat, projMat, _x, _y) {
	/*
		Transforms a 2D coordinate (in window space) to a 3D vector.
		Returns an array of the following format:
		[dx, dy, dz, ox, oy, oz]
		where [dx, dy, dz] is the direction vector and [ox, oy, oz] is the origin of the ray.
		Remove windows_width/height reference, x, y range from 0 to 1.

		Works for both orthographic and perspective projections.

		Script created by TheSnidr
	*/
	var V = viewMat;
	var P = projMat;

	var mx = 2 * (_x - .5) / P[0];
	var my = 2 * (_y - .5) / P[5];
	var camX = - (V[12] * V[0] + V[13] * V[1] + V[14] * V[2]);
	var camY = - (V[12] * V[4] + V[13] * V[5] + V[14] * V[6]);
	var camZ = - (V[12] * V[8] + V[13] * V[9] + V[14] * V[10]);

	if (P[15] == 0) 
	{    //This is a perspective projection
	    return [V[2]  + mx * V[0] - my * V[1], 
	            V[6]  + mx * V[4] - my * V[5], 
	            V[10] + mx * V[8] - my * V[9], 
	            camX, 
	            camY, 
	            camZ];
	}
	else 
	{    //This is an ortho projection
	    return [V[2], 
	            V[6], 
	            V[10], 
	            camX + mx * V[0] - my * V[1], 
	            camY + mx * V[4] - my * V[5], 
	            camZ + mx * V[8] - my * V[9]];
	}
}

function view_frustum(xfrom, yfrom, zfrom, xto, yto, zto, xup, yup, zup, fov, aspect, near, far, struct=-1)
{
	// This create a frustum to check quickly with view_frustum_check
	// value will be added to struct, if no struct are provided, new struct will be returned
	var d;
	xto = xto - xfrom;	// get view vector
	yto = yto - yfrom;
	zto = zto - zfrom;

	d = sqrt(xto*xto+yto*yto+zto*zto);	// normalize view vector
	xto/=d;
	yto/=d;
	zto/=d;

	d = xup*xto+yup*yto+zup*zto;	// get up vector
	xup -= d*xto;
	yup -= d*yto;
	zup -= d*zto;
	d = sqrt(xup*xup+yup*yup+zup*zup);
	xup/=d;
	yup/=d;
	zup/=d;

	var ytan = tan(degtorad(fov)/2);	// get view angle
	var xtan = ytan*aspect;

	if struct=-1 return {
		xfrom: xfrom,
		yfrom: yfrom,
		zfrom: zfrom,
	
		xto: xto,
		yto: yto,
		zto: zto,
	
		xup: xup,
		yup: yup,
		zup: zup,
	
		xcross: yup*zto-zup*yto,
		ycross: zup*xto-xup*zto,
		zcross: xup*yto-yup*xto,
	
		ytan: ytan,
		xtan: xtan,
		xsec: sqrt(1+sqr(xtan)),
		ysec: sqrt(1+sqr(ytan)),
		znear: near,
		zfar: far
	} else {
		struct.xfrom = xfrom;
		struct.yfrom = yfrom;
		struct.zfrom = zfrom;
	
		struct.xto = xto;
		struct.yto = yto;
		struct.zto = zto;
	
		struct.xup = xup;
		struct.yup = yup;
		struct.zup = zup;
	
		struct.xcross = yup*zto-zup*yto;
		struct.ycross = zup*xto-xup*zto;
		struct.zcross = xup*yto-yup*xto;
	
		struct.ytan = ytan;
		struct.xtan = xtan;
		struct.xsec = sqrt(1+sqr(xtan));
		struct.ysec = sqrt(1+sqr(ytan));
		struct.znear = near;
		struct.zfar = far
	}
}

function view_frustum_check(frustum, x,y,z, radius=0)
{
	// Check if a point is visible inside view frustum (create with view_frustum)
	var xx, yy, zz;

	zz = frustum.xto*(x-frustum.xfrom)+frustum.yto*(y-frustum.yfrom)+frustum.zto*(z-frustum.zfrom);
	if zz<frustum.znear-radius or zz>frustum.zfar+radius {return false;}

	xx = frustum.xcross*(x-frustum.xfrom)+frustum.ycross*(y-frustum.yfrom)+frustum.zcross*(z-frustum.zfrom);
	if abs(xx)>zz*frustum.xtan+radius*frustum.xsec {return false;}

	yy = frustum.xup*(x-frustum.xfrom)+frustum.yup*(y-frustum.yfrom)+frustum.zup*(z-frustum.zfrom);
	if abs(yy)>zz*frustum.ytan+radius*frustum.ysec {return false;}

	return true;
}

function calculate_smooth_normals(buffer) {    
	ds_map_clear(global.temp_map)
	var normal_cache = global.temp_map;
    for (var i = 0; i < buffer_get_size(buffer); i += 36 * 3) {
        var x1 = buffer_peek(buffer, i + 00, buffer_f32);
        var y1 = buffer_peek(buffer, i + 04, buffer_f32);
        var z1 = buffer_peek(buffer, i + 08, buffer_f32);
		
        var x2 = buffer_peek(buffer, i + 36, buffer_f32);
        var y2 = buffer_peek(buffer, i + 40, buffer_f32);
        var z2 = buffer_peek(buffer, i + 44, buffer_f32);
        
        var x3 = buffer_peek(buffer, i + 72, buffer_f32);
        var y3 = buffer_peek(buffer, i + 76, buffer_f32);
        var z3 = buffer_peek(buffer, i + 80, buffer_f32);
        
        var v1 = [x1, y1, z1];
        var v2 = [x2, y2, z2];
        var v3 = [x3, y3, z3];
        
		var e1 = [v2[0] - v1[0], v2[1] - v1[1], v2[2] - v1[2]]
		var e2 = [v3[0] - v1[0], v3[1] - v1[1], v3[2] - v1[2]]
        //var e1 = v2.Sub(v1);
        //var e2 = v3.Sub(v1);
        
        // Calculate the flat normals for each triangle, as before
        //var norm = e1.Cross(e2).Normalize();
		var norm = array_create(3)
		cross_product(e1, e2, norm)
		vector_normalize(norm)
        
        // Keep the flat normals in the vertex buffer; we'll need
        // them later to decide if a vertex should be smoothed or not
        buffer_poke(buffer, i + 12, buffer_f32, norm[0]);
        buffer_poke(buffer, i + 16, buffer_f32, norm[1]);
        buffer_poke(buffer, i + 20, buffer_f32, norm[2]);
        
        buffer_poke(buffer, i + 48, buffer_f32, norm[0]);
        buffer_poke(buffer, i + 52, buffer_f32, norm[1]);
        buffer_poke(buffer, i + 56, buffer_f32, norm[2]);
        
        buffer_poke(buffer, i + 84, buffer_f32, norm[0]);
        buffer_poke(buffer, i + 88, buffer_f32, norm[1]);
        buffer_poke(buffer, i + 92, buffer_f32, norm[2]);
        
        // Generate a unique identifier for each vertex
        var v1_key = string(x1) + "," + string(y1) + "," + string(z1);
        var v2_key = string(x2) + "," + string(y2) + "," + string(z2);
        var v3_key = string(x3) + "," + string(y3) + "," + string(z3);
        
        // If each vertex does not have a cached normal yet, cache
        // the normal we just calculated; otherwise, add the normal
        // we just calculated to whatever's already there
        if (!ds_map_exists(normal_cache, v1_key)) {
            normal_cache[? v1_key] = norm;
        } else {
			array_add(normal_cache[? v1_key], norm)
        }
        
        if (!ds_map_exists(normal_cache, v2_key)) {
            normal_cache[? v2_key] = norm;
        } else {
			array_add(normal_cache[? v2_key], norm)
        }
        
        if (!ds_map_exists(normal_cache, v3_key)) {
            normal_cache[? v3_key] = norm;
        } else {
			array_add(normal_cache[? v3_key], norm)
        }
    }
    
    for (var i = 0; i < buffer_get_size(buffer); i += 36) {
        var xx = buffer_peek(buffer, i + 00, buffer_f32);
        var yy = buffer_peek(buffer, i + 04, buffer_f32);
        var zz = buffer_peek(buffer, i + 08, buffer_f32);
        var nx = buffer_peek(buffer, i + 12, buffer_f32);
        var ny = buffer_peek(buffer, i + 16, buffer_f32);
        var nz = buffer_peek(buffer, i + 20, buffer_f32);
        
        // Iterating over each vertex in the mesh a second time,
        // look the vertex up in the cache and normalize the result
        var vertex_key = string(xx) + "," + string(yy) + "," + string(zz);
        var existing_normal = [nx, ny, nz];
		norm = normal_cache[? vertex_key]
		vector_normalize(norm)
        
        // If the smoothed normal is similar enough to the
        // vertex's flat normal, assign the smoothed normal
        // to it; otherwise, leave it alone
		//if dot_product_3d(existing_normal[0], existing_normal[1], existing_normal[2], norm[0], norm[1], norm[2]) > threshold 
		{
            buffer_poke(buffer, i + 12, buffer_f32, norm[0]);
            buffer_poke(buffer, i + 16, buffer_f32, norm[1]);
            buffer_poke(buffer, i + 20, buffer_f32, norm[2]);
		}        
        // Note: there may other ways you may wish to decide
        // if a normal should be smoothed or not, depending on
        // the specifics of what you're trying to do
    }
    
	ds_map_clear(global.temp_map)
    return true;
}


function rotate_point_x(pointX, pointY, originX, originY, angle) {
	var a = degtorad(angle);
	return cos(a) * (pointX-originX) - sin(a) * (pointY-originY) + originX}
	
function rotate_point_y(pointX, pointY, originX, originY, angle) {
	var a = degtorad(angle);
	return sin(a) * (pointX-originX) + cos(a) * (pointY-originY) + originY}

function line_intersect_plane(x1, y1, z1, x2, y2, z2, plane_pos, plane_normal)
{    
    var w = [x1-plane_pos[0], y1-plane_pos[1], z1-plane_pos[2]];
	var v = [x2-x1, y2-y1, z2-z1];
	var dot = dot_product_3d(v[0], v[1], v[2], plane_normal[0], plane_normal[1], plane_normal[2]);
	if dot=0 return false;
	var fac =  - dot_product_3d(w[0], w[1], w[2], plane_normal[0], plane_normal[1], plane_normal[2]) / dot;
	return [x1+v[0]*fac, y1+v[1]*fac, z1+v[2]*fac]
}
/*
function build_lookat_matrix(xfrom, yfrom, zfrom, xto, yto, zto, xup, yup, zup)	// WIP
{
	var zaxis = normalize([xto-xfrom, yto-yfrom, zto-zfrom]);
	var xaxis = normalize(cross_product(zaxis, [xup, yup, zup]));
	var yaxis = cross_product(xaxis, zaxis);
	
	//array_multiply(zaxis, -1)
	
	var mat = array_create(4*4);
	mat[@0]=xaxis[0]; mat[@4]=yaxis[1]; mat[@8]=xaxis[2]; mat[@12]=-dot_product_3d(xaxis[0],xaxis[1],xaxis[2], xfrom, yfrom, zfrom);
	mat[@1]=yaxis[0]; mat[@5]=yaxis[1]; mat[@9]=yaxis[2]; mat[@13]=-dot_product_3d(yaxis[0],yaxis[1],yaxis[2], xfrom, yfrom, zfrom);
	mat[@2]=zaxis[0]; mat[@6]=zaxis[1]; mat[@10]=zaxis[2]; mat[@14]=-dot_product_3d(zaxis[0],zaxis[1],zaxis[2], xfrom, yfrom, zfrom);
	mat[@3]=0; mat[@7]=0; mat[@11]=0; mat[@15]=1;
	return mat;
}
*/
/*
function point_line_distance(px,py,x1,y1,x2,y2,segment) {
    /// GMLscripts.com/license
        var dx, dy, t, x0, y0;
        dx = x2-x1;
        dy = y2-y1;
        if ((dx == 0) && (dy == 0)) 
        {
            x0 = x1;
            y0 = y1;
        }
        else
        {
            t = (dx*(px-x1) + dy*(py-y1)) / (dx*dx+dy*dy);
            if (segment) t = clamp(t, 0, 1);
            x0 = x1 + t * dx;
            y0 = y1 + t * dy;
        }
        return point_distance(x0, y0, px, y1);
    }