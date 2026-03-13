FROM osrf/ros:humble-desktop

# Container environment configuration
ENV DEBIAN_FRONTEND=noninteractive \
	LANG=en_US.UTF-8 \
	LC_ALL=en_US.UTF-8 \
	HOME=/root \
	ROS_DISTRO=humble

WORKDIR /root

# Install essential build tools and ROS utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
	lsb-release \
	gnupg \
	curl \
	wget \
	build-essential \
	python3-pip \
	python3-colcon-common-extensions \
	python3-vcstool \
	locales \
	git \
	&& locale-gen en_US.UTF-8 \
	&& update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
	&& rm -rf /var/lib/apt/lists/*

# Create ROS2 workspace structure
RUN mkdir -p /root/ros2_ws/src
COPY tmp_sources/ /root/ros2_ws/src/
RUN find /root/ros2_ws/src -name joy_to_cmdvel.py -exec chmod +x {} \;
WORKDIR /root/ros2_ws

# Install ROS2 dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
	ros-humble-geometry-msgs \
	ros-humble-std-msgs \
	ros-humble-tf2 \
	ros-humble-tf2-ros \
	ros-humble-urdf \
	ros-humble-xacro \
	ros-humble-rviz2 \
	ros-humble-realsense2-description \
	ros-humble-robot-state-publisher \
	ros-humble-joint-state-publisher-gui \
	ros-humble-ros-gz \
	ros-humble-ros-gz-sim \
	ros-humble-ros-gz-bridge \
	ros-humble-rqt-tf-tree \
	ros-humble-joy \
	&& rm -rf /var/lib/apt/lists/*

# Build the ROS2 workspace
RUN /bin/bash -lc "source /opt/ros/${ROS_DISTRO}/setup.bash && colcon build --symlink-install"

# Create a script that configures the ROS2 environment and executes the command passed as argument
# Required to run colcon build directly inside the container
RUN echo '#!/bin/bash' > /entrypoint.sh && \
	echo 'source /opt/ros/humble/setup.bash' >> /entrypoint.sh && \
	echo 'source /root/ros2_ws/install/local_setup.bash' >> /entrypoint.sh && \
	echo 'export GZ_SIM_RESOURCE_PATH=/root/ros2_ws/install/fra2mo_description/share:$GZ_SIM_RESOURCE_PATH' >> /entrypoint.sh && \
	echo 'export ROS_DOMAIN_ID=97' >> /entrypoint.sh && \
	echo 'exec "$@"' >> /entrypoint.sh && \
	chmod +x /entrypoint.sh

# Configure the ROS2 environment
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc \
	&& echo "source /root/ros2_ws/install/local_setup.bash" >> /root/.bashrc \
	&& echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> /root/.bashrc \
	&& echo "export _colcon_cd_root=/opt/ros/humble/" >> /root/.bashrc \
	&& echo "export GZ_SIM_RESOURCE_PATH=/root/ros2_ws/install/fra2mo_description/share:\$GZ_SIM_RESOURCE_PATH" >> /root/.bashrc \
	&& echo "export ROS_DOMAIN_ID=97" >> /root/.bashrc

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /root/ros2_ws
CMD ["/bin/bash", "-i"]
