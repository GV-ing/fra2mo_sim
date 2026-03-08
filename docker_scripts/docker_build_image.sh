#!/bin/bash
cd "$(dirname "$0")"


# Start the Docker image build
rm -rf ./tmp_sources
mkdir -p ./tmp_sources
cp -r ../src/* ./tmp_sources

docker build -t robot_description -f ./Dockerfile .

rm -rf ./tmp_sources

echo "Build completed. Start the container with: ./docker_run_container.sh"