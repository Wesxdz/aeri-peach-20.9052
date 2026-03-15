include <vertex_structure.scad>
include <lift_mount_vertex_connector.scad>

module VertexNotch(sections=[1, 1, 1], vertex_variant=0)
{
    intersection()
    {
        PiSections(sections);
        if (vertex_variant == 1) // Default vertex structure
        {
            //VertexStructure(height = 1.5, rounding = 0.2, truncate=vertex_tehtra_height_truncation, prism_radius = 0.0, vertex_cut=2.5, pent_h=pcorner_dist, secure=0);
        } else if (vertex_variant == 2)
        {
            // TODO: Support asymmetrical vertex connector placement...
            //scale(.1) import("lift_mount_vertex_connector.stl");
            //IntegratedLift();
        } else if (vertex_variant == 3)
        {
            //import("lift_stabilizer.stl");
            VertexStructure(height = 2.2, rounding = 0.2, truncate=vertex_tehtra_height_truncation*1.5, prism_radius = 4.3, pent_h=5.0, vertex_cut=1, secure=1);
        }
    }
}