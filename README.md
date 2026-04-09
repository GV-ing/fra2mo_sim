# fra2mo_sim

## Overview

This repository contains the core packages used to simulate **fra2mo**, a differential-drive mobile robot developed for educational and research purposes.

The project has two main goals:

1. **Technical reference**: document the software architecture and runtime logic of the robot in a ROS 2 Humble environment.
2. **Operational guide**: provide a practical workflow for developing, extending, and testing a generic differential-drive robot in simulation before deploying software to real hardware.

The repository is designed to provide a reproducible development environment based on Docker, reducing host-side dependency conflicts and making the simulation stack easier to share across different machines.

## Repository Structure

The workspace is organized around two main directories:

- **`docker_scripts/`**: scripts and configuration used to build, run, and access the Docker-based development environment.
- **`src/`**: ROS 2 packages and simulation assets, including robot description, navigation configuration, sensors, maps, and launch files.

This setup keeps the host system clean while giving every developer the same execution environment.

## Docker Environment

The `docker_scripts/` directory contains the automation needed to manage the container lifecycle.

| File | Purpose |
| :--- | :--- |
| **`Dockerfile`** | Defines the base image built around Ubuntu 22.04 and ROS 2 Humble, installs Gazebo Harmonic support, and prepares the workspace used inside the container. |
| **`docker_build_image.sh`** | Builds the Docker image. Run it the first time and whenever the Dockerfile changes. |
| **`docker_run_container.sh`** | Starts the container and configures X11 forwarding so GUI applications such as Gazebo and RViz can run from inside the container. |
| **`docker_connect.sh`** | Opens an additional shell inside a running container, which is useful for monitoring topics or running commands in parallel. |

### Why Docker Is Used

Containerization is a technical choice, not just a convenience feature. It provides:

1. **Isolation**: every developer uses the same versions of ROS 2, Nav2, Gazebo, and related dependencies.
2. **Faster setup**: environment provisioning takes minutes instead of manually reproducing a full robotics stack.
3. **Portability**: software developed in simulation can be transferred more reliably to the onboard computer used on the real robot.

## Quick Start

To prepare and launch the environment for the first time:

```bash
chmod +x docker_scripts/*.sh
./docker_scripts/docker_build_image.sh
./docker_scripts/docker_run_container.sh
```

Once the container is running, you can attach additional shells with:

```bash
./docker_scripts/docker_connect.sh
```

## ROS 2 Packages in `src`

The `src/` directory contains the main ROS 2 packages that define the **fra2mo** simulation stack. The workspace is split into two complementary modules: one focused on robot modeling and simulation assets, and one focused on navigation.

### fra2mo_description

This package defines the physical and visual representation of the robot. It includes the URDF/Xacro description, simulated sensors, Gazebo worlds, RViz configuration, and custom support nodes.

#### Main contents

- **`urdf/`**: Xacro files describing the differential-drive robot, including links, joints, and reusable sensor macros.
- **`meshes/`** and **`models/`**: 3D geometry and simulation assets for the robot and the environment.
- **`worlds/`**: SDF worlds used in simulation, including the race field environment.
- **`launch/`**: launch files used to start the robot description stack, Gazebo, and RViz.
- **`conf/`**: RViz configuration files for a ready-to-use visualization setup.
- **`src/`**: custom nodes, such as the joystick-to-`cmd_vel` interface.
- **`CMakeLists.txt`** and **`package.xml`**: build configuration and package metadata.

### fra2mo_navigation

This package contains the navigation stack configuration and spatial perception tools used by the robot.

#### Main contents

- **`maps/`**: maps generated or used by localization and navigation workflows.
- **`launch/`**: launch files for SLAM and AMCL workflows.
- **`config/`**: Nav2 parameter files used to configure autonomous navigation behavior.
- **`CMakeLists.txt`** and **`package.xml`**: build configuration and package metadata.

#### Main capabilities

- **SLAM (Simultaneous Localization and Mapping)**: allows the robot to map an unknown environment using lidar and odometry data.
- **AMCL (Adaptive Monte Carlo Localization)**: localizes the robot inside a previously generated map.
- **Nav2 integration**: provides planners, controllers, and recovery behaviors for autonomous navigation and obstacle avoidance.

## Submodules

The packages inside `src/` are managed as Git submodules:

- `src/fra2mo_description`
- `src/fra2mo_navigation`

If you clone the repository from scratch, initialize them with:

```bash
git submodule update --init --recursive
```

If the submodule pointers are updated in this repository, make sure to pull the latest changes and refresh them locally.

## Build Notes

Both packages follow the standard ROS 2 packaging workflow and are intended to be built with `colcon`. After building the workspace, assets such as meshes, launch files, maps, and URDF resources are installed into the workspace `install/` directory and become available to ROS 2 launch tooling.

Typical build command inside the container:

```bash
colcon build
source install/setup.bash
```

## Purpose of This Repository

`fra2mo_sim` is intended to be both a simulation workspace and a reference template for differential-drive robotics projects. It can be used to:

- study the structure of a ROS 2 robot simulation project,
- prototype robot behavior before testing on hardware,
- extend sensors, worlds, and navigation features,
- maintain a reproducible robotics environment for a team.
