
 
## Fra2mo Simulation Project

This repository provides everything needed to simulate Fra2mo:
**docker_scripts/**: scripts to start and install libraries via Docker
**src/**: contains submodules as:
    - `fra2mo_description` package for visualization in Gazebo and Rviz

#### Docker setup
1. Build the container:
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

---