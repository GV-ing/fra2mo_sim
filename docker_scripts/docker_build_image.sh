#!/bin/bash
cd "$(dirname "$0")"

# Start the Docker image build
rm -rf ./tmp_sources
mkdir -p ./tmp_sources

# Ensure source files exist before copying
if [ -d "../src" ]; then
  cp -r ../src/* ./tmp_sources
else
  echo "Error: Source directory ../src does not exist. Exiting."
  exit 1
fi

docker build -t robot_description -f ./Dockerfile .

rm -rf ./tmp_sources

echo "Build completed. Start the container with: ./docker_run_container.sh"