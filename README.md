## Fra2mo Simulation Project


This repository provides everything needed to simulate Fra2mo:

- **docker_scripts/**: scripts to start and install libraries via Docker
- **src/**: contains submodules, including:
	- `fra2mo_description` package for visualization in Gazebo and Rviz
	- `fra2mo_navigation` package for autonomous navigation.

#### Docker setup
1. Build the container (/fra2mo_sim/docker_scripts):

	 ```bash
	 ./docker_scripts/docker_build_image.sh
	 ```

2. Start or connect to the container:

	 ```bash
	 ./docker_scripts/docker_run_container.sh
	 # or
	 ./docker_scripts/docker_connect.sh
	 ```


#### fra2mo_description 
Inside the container, launch the simulation:

- Gazebo:
	```bash
	ros2 launch fra2mo_description fra2mo_gazebo.launch.py
	```
- Rviz:
	```bash
	ros2 launch fra2mo_description fra2mo_rviz.launch.py
	```

#### fra2mo_navigation
Start the navigation stack:

1. SLAM
   ```bash
   ros2 launch fra2mo_navigation slam.launch.py
   ```
   Save the map with:
   ```bash
   ros2 run nav2_map_server map_saver_cli -f <maps_name>
   ```

2. AMCL
   Pay attention to the map path:
   ```bash
   ros2 launch fra2mo_navigation amcl.launch.py