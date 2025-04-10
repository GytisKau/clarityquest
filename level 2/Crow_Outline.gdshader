shader_type spatial;
render_mode unshaded;

// Define a uniform for the color with a color picker
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Default red color

void fragment() {
    // Set the final color of the object to the selected color
    ALBEDO = color.rgb; // Use only the RGB part of the vec4 for the albedo
    ALPHA = color.a;     // Use the alpha part for transparency
}