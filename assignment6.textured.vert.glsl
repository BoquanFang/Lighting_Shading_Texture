#version 300 es

// an attribute will receive data from a buffer
in vec3 a_position;
in vec3 a_normal;
in vec3 a_tangent;
in vec2 a_texture_coord;

// transformation matrices
uniform mat4x4 u_m;
uniform mat4x4 u_v;
uniform mat4x4 u_p;

// output to fragment stage
// TODO: Create varyings to pass data to the fragment stage (position, texture coords, and more)
out vec2 TexCoords;
out mat3 TBN;
out vec3 o_vertex_position_world;




void main() {

    // transform a vertex from object space directly to screen space
    // the full chain of transformations is:
    // object space -{model}-> world space -{view}-> view space -{projection}-> clip space
    vec4 vertex_position_world = u_m * vec4(a_position, 1.0);
    vec3 vertex_position = vec3(vertex_position_world[0], vertex_position_world[1], vertex_position_world[2]);
    // TODO: Construct TBN matrix from normals, tangents and bitangents
    // TODO: Use the Gram-Schmidt process to re-orthogonalize tangents
    // NOTE: Different from the book, try to do all calculations in world space using the TBN to transform normals
    // HINT: Refer to https://learnopengl.com/Advanced-Lighting/Normal-Mapping for all above
    mat3 tbn = mat3(0);
    // According to the website, the cross product of T and N is B.
    vec3 T = normalize(vec3(u_m * vec4(a_tangent, 0.0)));
    vec3 N = normalize(vec3(u_m * vec4(a_normal, 0.0)));
    T = normalize(T - dot(T, N) * N);
    vec3 bitangents = cross(N, T);
    vec3 B = normalize(vec3(u_m * vec4(bitangents, 0.0)));
    tbn = mat3(T, B, N);    

    // TODO: Forward data to fragment stage
    TexCoords = a_texture_coord;
    TBN = tbn;
    mat3 norm_matrix = transpose(inverse(mat3(u_m)));
    vec3 vertex_normal_world = normalize(norm_matrix * a_normal);
    o_vertex_position_world = vertex_position;

    gl_Position = u_p * u_v * vertex_position_world;

}