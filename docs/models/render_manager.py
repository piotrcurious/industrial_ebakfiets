import subprocess
import os

renders = [
    {"out": "../renders/final_iso.png", "cam": "0,0,0,65,0,25,2500", "scad": "full_assembly.scad", "call": ""},
    {"out": "../renders/final_side.png", "cam": "0,0,0,90,0,0,2500", "scad": "full_assembly.scad", "call": ""},
    {"out": "../renders/final_top.png", "cam": "0,0,0,0,0,0,2500", "scad": "full_assembly.scad", "call": ""},
    {"out": "../renders/final_front.png", "cam": "0,0,0,90,0,90,2500", "scad": "full_assembly.scad", "call": ""},
    {"out": "../renders/front_wheel_assy_perspective.png", "cam": "0,0,0,65,0,25,800", "scad": "front_wheel_assy.scad", "call": "front_wheel_assy();"},
    {"out": "../renders/front_fork_front.png", "cam": "45,0,500,90,0,90,1200", "scad": "front_fork.scad", "call": "front_fork_assy();"},
    {"out": "../renders/frame_side.png", "cam": "800,0,-200,90,0,0,2200", "scad": "frame.scad", "call": "frame_assy();"},
    {"out": "../renders/steering_head_perspective.png", "cam": "0,0,0,65,0,25,500", "scad": "steering_head.scad", "call": "steering_head_assy();"}
]

def run_render(r):
    print(f"Rendering {r['out']}...")
    models_dir = "docs/models"
    temp_scad_path = os.path.join(models_dir, "temp_render.scad")

    with open(temp_scad_path, "w") as f:
        f.write(f'include <{r["scad"]}>\n')
        if r["call"]:
            f.write(r["call"])

    cmd = [
        "xvfb-run", "-a", "openscad",
        "-o", r["out"],
        "--imgsize=1200,1200",
        f"--camera={r['cam']}",
        "temp_render.scad"
    ]
    try:
        subprocess.run(cmd, check=True, cwd=models_dir)
        print(f"Finished {r['out']}")
    except subprocess.CalledProcessError as e:
        print(f"Failed to render {r['out']}: {e}")
    finally:
        if os.path.exists(temp_scad_path):
            os.remove(temp_scad_path)

if __name__ == "__main__":
    os.makedirs("docs/renders", exist_ok=True)
    for r in renders:
        run_render(r)
