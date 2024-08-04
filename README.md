# WALL-E

This repository contains the source code for a mobile application developed as part of a graduation project. The app uses a deep learning model to classify plant diseases and facilitates the control and monitoring of a drone used to scan agricultural fields. The mobile solution is built with Flutter and integrates various technologies for comprehensive, real-time functionality.

## Features

### Mobile App Functionality

1. *Image Classification*:
   - Users can capture images using the mobile camera.
   - These images are processed through a deep learning model to classify plant diseases.
   - Provides classification results and an option to query the Gemini API for more information about the disease.

2. *Drone Interaction*:
   - Enables communication with a drone to perform scans over agricultural fields.
   - Users can control and monitor drone operations directly through the app.

### Drone Features

1. *Area Selection*:
   - Incorporates Google Maps API to show the drone's current location and to select a designated search area.
   - The search area is defined by selecting four points on the map.
   - Coordinates are sent to Firebase.

2. *Grid Creation*:
   - After area selection, the drone generates a grid of waypoints to ensure complete coverage of the field.
   - Waypoints are communicated to Firebase, allowing users to view the search area in real-time.

3. *Image Capture at Waypoints*:
   - The drone captures images at each waypoint and uploads them to Firebase Storage.
   - Images are then fetched by the app and processed through the plant disease classification model.
   - Users can also query Gemini for further insights on detected diseases.

4. *Live Video Streaming*:
   - During its flight, the drone streams video using the ROS web_video_server package.
   - The app accesses this stream via HTTP, enabling live viewing of the drone's flight.

## Technologies Used

- *Mobile App*: Flutter
- *Deep Learning Model*: Customized model for plant disease classification
- *Drone Control*:
  - Firmware: ArduPilot
  - Communication: MAVROS, ROS
  - Simulation: SITL, Gazebo
- *Data Management*: Firebase (Real-time Database, Storage)
- *Mapping*: Google Maps API
- *Video Streaming*: ROS web_video_server

## Setup and Installation

1. *Clone the repository*:
- git clone https://github.com/yourusername/yourrepository.git
2. *Install necessary dependencies*:
- Detailed commands to install Flutter, ROS, and any other necessary libraries and tools.
3. *Environment setup*:
- Instructions for setting up the development environment specific to the mobile app and drone simulation.

## Usage

1. *Starting the App*:
- Instructions on launching the app and performing initial configuration.
2. *Connecting to the Drone*:
- Steps to establish a connection between the app and the drone.
3. *Performing a Field Scan*:
- Guidelines on how to use the app to initiate and monitor a field scan.

## Contributing

- Fork the repository, create a new branch, make changes, and submit a pull request.
- Adhere to the provided code style guidelines and document all changes.

## Contact

For support or collaboration, please contact me at [mariaroshdy17@gmail.com](mariaroshdy17@gmail.com).

## Acknowledgments
- Utilizes technologies such as Firebase and Google Maps API, among others.
