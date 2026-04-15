import subprocess
import os

# Get the directory where the script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

renders = [
    {"out": "../renders/full_assembly_perspective.png", "cam": "700,0,300,65,0,25,4500", "scad": "full_assembly.scad", "call": ""},
    {"out": "../renders/final_side.png", "cam": "700,0,300,90,0,0,4500", "scad": "full_assembly.scad", "call": ""},
    {"out": "../renders/final_top.png", "cam": "700,0,0,0,0,0,4500", "scad": "full_assembly.scad", "call": ""},
    {"out": "../renders/final_front.png", "cam": "0,0,300,90,0,90,2500", "scad": "full_assembly.scad", "call": ""},
    {"out": "../renders/front_wheel_assy_perspective.png", "cam": "0,0,0,65,0,25,800", "scad": "front_wheel_assy.scad", "call": "front_wheel_assy();"},
    {"out": "../renders/front_wheel_exploded.png", "cam": "0,0,0,65,0,45,1500", "scad": "front_wheel_exploded.scad", "call": ""},
    {"out": "../renders/front_wheel_xray.png", "cam": "0,0,0,65,0,25,1200", "scad": "front_wheel_xray.scad", "call": ""},
    {"out": "../renders/front_fork_front.png", "cam": "45,0,500,90,0,90,1200", "scad": "front_fork.scad", "call": "front_fork_assy();"},
    {"out": "../renders/frame_side.png", "cam": "800,0,-200,90,0,0,2200", "scad": "frame.scad", "call": "frame_assy();"},
    {"out": "../renders/steering_head_perspective.png", "cam": "0,0,0,65,0,25,500", "scad": "steering_head.scad", "call": "steering_head_assy();"}
]

def run_render(r):
    print(f"Rendering {r['out']}...")
    temp_scad_path = os.path.join(script_dir, "temp_render.scad")

    with open(temp_scad_path, "w") as f:
        f.write(f'include <{r["scad"]}>\n')
        if r["call"]:
            f.write(r["call"])

    out_path = os.path.normpath(os.path.join(script_dir, r["out"]))

    cmd = [
        "xvfb-run", "-a", "openscad",
        "-o", out_path,
        "--imgsize=1200,1200",
        f"--camera={r['cam']}",
        "temp_render.scad"
    ]
    try:
        subprocess.run(cmd, check=True, cwd=script_dir)
        print(f"Finished {r['out']}")
    except subprocess.CalledProcessError as e:
        print(f"Failed to render {r['out']}: {e}")
    finally:
        if os.path.exists(temp_scad_path):
            os.remove(temp_scad_path)

if __name__ == "__main__":
    os.makedirs(os.path.join(script_dir, "../renders"), exist_ok=True)
    for r in renders:
        run_render(r)
