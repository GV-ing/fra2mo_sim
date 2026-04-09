#!/bin/bash
THISDIR=$(dirname "$(realpath "$0")")

IMAGE_NAME="fra2mo_simulation_image"
IMAGE_ID=$(docker images -q "$IMAGE_NAME")
CNT_NAME="fra2mo_simulation_cnt"

CONTAINER_CMD=(bash)
if [[ "$1" == "--build" ]]; then
	CONTAINER_CMD=(bash -lc "source /opt/ros/humble/setup.bash && colcon build --symlink-install && source /root/ros2_ws/install/setup.bash && exec bash -i")
fi
xhost +local:root
docker run --rm -it --net=host \
	--env="DISPLAY=$DISPLAY" \
	--env="QT_X11_NO_MITSHM=1" \
	--env="XDG_RUNTIME_DIR=/tmp/runtime-root" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--volume="$THISDIR/../src:/root/ros2_ws/src:rw" \
	--device=/dev/dri:/dev/dri \
	--privileged \
	"${DOCKER_VOLUMES_ARGS[@]}" \
	--name="$CNT_NAME" \
	--workdir "/root/ros2_ws" \
	"$IMAGE_NAME" \
	"${CONTAINER_CMD[@]}"

xhost -local:root
