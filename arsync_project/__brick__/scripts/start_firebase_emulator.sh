#!/bin/bash

# Colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Firebase Emulator Management Script${NC}"

# Function to check if a port is in use
check_port() {
  lsof -i:$1 >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${RED}Port $1 is in use.${NC}"
    return 0
  else
    return 1
  fi
}

# Function to kill process using a specific port
kill_port_process() {
  local PORT=$1
  local PID=$(lsof -t -i:$PORT)
  
  if [ ! -z "$PID" ]; then
    # echo -e "${YELLOW}Killing process $PID using port $PORT...${NC}"
    kill -9 $PID 2>/dev/null
    sleep 1
  fi
}

# Kill any running firebase emulators
kill_firebase_emulators() {
  echo -e "${YELLOW}Checking for running Firebase emulators...${NC}"
  
  local EMULATOR_PIDS=$(ps aux | grep "firebase emulators" | grep -v grep | awk '{print $2}')
  
  if [ -z "$EMULATOR_PIDS" ]; then
    echo -e "${GREEN}No running Firebase emulators found.${NC}"
  else
    echo -e "${YELLOW}Found running emulators. Killing processes...${NC}"
    echo $EMULATOR_PIDS | xargs kill -9 2>/dev/null
    sleep 2
    echo -e "${GREEN}Emulators terminated.${NC}"
  fi
}

# Check and free up required ports
free_up_ports() {
  echo -e "${YELLOW}Checking emulator ports...${NC}"
  
  local PORTS=(9099 5001 8080 9199 4000)
  local PORT_NAMES=("Auth" "Functions" "Firestore" "Storage" "UI")
  
  for i in "${!PORTS[@]}"; do
    if check_port ${PORTS[$i]}; then
      echo -e "${YELLOW}Freeing up ${PORT_NAMES[$i]} port ${PORTS[$i]}...${NC}"
      kill_port_process ${PORTS[$i]}
      if check_port ${PORTS[$i]}; then
        echo -e "${RED}Failed to free up port ${PORTS[$i]}. Please check manually.${NC}"
      else
        echo -e "${GREEN}Port ${PORTS[$i]} is now available.${NC}"
      fi
    else
      echo -e "${GREEN}Port ${PORTS[$i]} is available.${NC}"
    fi
  done
}

# Check if Firebase Functions are enabled in firebase.json
check_functions_enabled() {
  if [ ! -f "firebase.json" ]; then
    echo -e "${RED}firebase.json not found.${NC}"
    return 1
  fi
  
  # Using grep to check if functions emulator is configured
  grep -q '"functions"' firebase.json
  return $?
}

# Build Firebase Functions
build_functions() {
  if [ ! -d "./functions" ]; then
    echo -e "${YELLOW}Functions directory not found. Skipping build.${NC}"
    return 1
  fi
  
  echo -e "${BLUE}Building Firebase Functions...${NC}"
  cd functions
  
  # Check if it's a npm or yarn project
  if [ -f "package-lock.json" ]; then
    echo -e "${BLUE}Using npm to build functions...${NC}"
    npm run build
  elif [ -f "yarn.lock" ]; then
    echo -e "${BLUE}Using yarn to build functions...${NC}"
    yarn build
  else
    # Default to npm if no lock file found
    echo -e "${BLUE}No lock file found. Using npm to build functions...${NC}"
    npm run build
  fi
  
  BUILD_RESULT=$?
  cd ..
  
  if [ $BUILD_RESULT -eq 0 ]; then
    echo -e "${GREEN}Firebase Functions built successfully.${NC}"
    return 0
  else
    echo -e "${RED}Firebase Functions build failed.${NC}"
    return 1
  fi
}

# Handle clean shutdown
cleanup() {
  echo -e "\n${YELLOW}Received shutdown signal. Cleaning up...${NC}"
  # Forward the signal to all processes in the process group
  kill -SIGINT 0
  wait
  echo -e "${GREEN}Emulator shutdown complete.${NC}"
  exit 0
}

# Set up trap to catch SIGINT and SIGTERM
trap cleanup SIGINT SIGTERM

# Main script execution starts here
kill_firebase_emulators
free_up_ports

# Check and build functions if enabled
if check_functions_enabled; then
  echo -e "${BLUE}Firebase Functions are enabled in your project.${NC}"
  build_functions
else
  echo -e "${YELLOW}Firebase Functions are not enabled. Skipping build.${NC}"
fi

echo -e "${YELLOW}Starting Firebase emulators...${NC}"

# Create firebase-data directory if it doesn't exist
mkdir -p ./firebase-data

# Start emulators with data persistence
echo -e "${GREEN}Using data directory: ./firebase-data${NC}"
firebase emulators:start --import=./firebase-data --export-on-exit=./firebase-data