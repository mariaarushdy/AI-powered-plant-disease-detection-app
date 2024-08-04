#!/usr/bin/env python3
# import firebase_admin
# from firebase_admin import credentials, db
# import math
# import rospy
# from std_msgs.msg import Float32MultiArray
# from sensor_msgs.msg import NavSatFix
# import os
# # Global variables to store latitudes and longitudes
# lat1 = 0.0
# lon1 = 0.0
# lat2 = 0.0
# lon2 = 0.0
# lat3 = 0.0
# lon3 = 0.0
# lat4 = 0.0
# lon4 = 0.0
# def haversine(lat1, lon1, lat2, lon2):
#     R = 6371000  # Radius of the Earth in meters
#     lat1 = math.radians(lat1)
#     lon1 = math.radians(lon1)
#     lat2 = math.radians(lat2)
#     lon2 = math.radians(lon2)
#     dlat = lat2 - lat1
#     dlon = lon2 - lon1
#     a = math.sin(dlat / 2)*2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon / 2)*2
#     c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
#     distance = R * c
#     return distance

# def calculate_bearing(lat1, lon1, lat2, lon2):
#     dlon = math.radians(lon2 - lon1)
#     lat1 = math.radians(lat1)
#     lat2 = math.radians(lat2)
#     x = math.sin(dlon) * math.cos(lat2)
#     y = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dlon)
#     bearing = math.atan2(x, y)
#     return bearing



# def generate_waypoints_grid(lat1, lon1, lat2, lon2, lat3, lon3, lat4, lon4, interval):
#     waypoints = []

#     # Calculate the distances and bearings
#     bottom_distance = haversine(lat1, lon1, lat2, lon2)
#     left_distance = haversine(lat1, lon1, lat4, lon4)
#     bottom_bearing = calculate_bearing(lat1, lon1, lat2, lon2)
#     left_bearing = calculate_bearing(lat1, lon1, lat4, lon4)
    
#     # Convert lat/lon to radians
#     lat1 = math.radians(lat1)
#     lon1 = math.radians(lon1)

#     for i in range(int(left_distance // interval) + 1):
#         for j in range(int(bottom_distance // interval) + 1):
#             d_vert = interval * i / 6371000  # interval in meters divided by Earth's radius in meters
#             d_horiz = interval * j / 6371000

#             # Calculate latitude and longitude for vertical movement
#             lat_vert = math.asin(math.sin(lat1) * math.cos(d_vert) + math.cos(lat1) * math.sin(d_vert) * math.cos(left_bearing))
#             lon_vert = lon1 + math.atan2(math.sin(left_bearing) * math.sin(d_vert) * math.cos(lat1), math.cos(d_vert) - math.sin(lat1) * math.sin(lat_vert))

#             # Calculate latitude and longitude for horizontal movement from the vertical position
#             lat_i = math.asin(math.sin(lat_vert) * math.cos(d_horiz) + math.cos(lat_vert) * math.sin(d_horiz) * math.cos(bottom_bearing))
#             lon_i = lon_vert + math.atan2(math.sin(bottom_bearing) * math.sin(d_horiz) * math.cos(lat_vert), math.cos(d_horiz) - math.sin(lat_vert) * math.sin(lat_i))

#             # Convert back to degrees
#             lat_i = math.degrees(lat_i)
#             lon_i = math.degrees(lon_i)

#             waypoints.append((lat_i, lon_i))
    
#     return waypoints

# def lonCallback(msg):
#     global lon1, lon2, lon3, lon4
#     arr = msg.data
#     lon1 = arr[0]
#     lon2 = arr[1]
#     lon3 = arr[2]
#     lon4 = arr[3]

# def latCallback(msg):
#     global lat1, lat2, lat3, lat4
#     arr = msg.data
#     #print(arr)
#     lat1 = arr[0]
#     lat2 = arr[1]
#     lat3 = arr[2]
#     lat4 = arr[3]

# def curPoseCallback(msg):
#     fl = 1
#     global curlat
    
#     global curlon 
    
#     if fl == 1:
#         curlat = msg.latitude
#         curlon = msg.longitude
#         fl = 0

# def save_waypoints(filename, waypoints):
#     if os.path.exists(filename):
#         os.remove(filename)
#     with open(filename, 'w') as f:
#         f.write('QGC WPL 110\n')
#         f.write(f"{0}\t1\t0\t16\t0.000000\t0.000000\t0.000000\t0.000000\t{curlat:.8f}\t{curlon:.8f}\t{alt:.8f}\t1\n")
#         f.write(f"{1}\t0\t3\t22\t0.000000\t0.000000\t0.000000\t0.000000\t{curlat:.8f}\t{curlon:.8f}\t{alt:.8f}\t1\n")
#         for i, (lat, lon) in enumerate(waypoints):
#             f.write(f"{i+2}\t0\t3\t16\t0.000000\t0.000000\t0.000000\t0.000000\t{lat:.8f}\t{lon:.8f}\t{alt:.8f}\t1\n")

#         f.write(f"{i+3}\t0\t0\t21\t0.000000\t0.000000\t0.000000\t0.000000\t{curlat:.8f}\t{curlon:.8f}\t{alt:.8f}\t1\n")


# def uptoFb(waypoints, ref):
#     print(len(waypoints))
#     ref.child("waypoints").delete()
#     ref.child(f"waypoints/wapoint{0:03}/latitude").set(curlat)
#     ref.child(f"waypoints/wapoint{0:03}/longitude").set(curlon)

#     for i, (lat, lon) in enumerate(waypoints):
#         ref.child(f"waypoints/wapoint{i+1:03}/latitude").set(lat)
#         ref.child(f"waypoints/wapoint{i+1:03}/longitude").set(lon)
#         rospy.sleep(0.5)
#     ref.child(f"waypoints/wapoint{i+2:03}/latitude").set(curlat)
#     ref.child(f"waypoints/wapoint{i+2:03}/longitude").set(curlon)


# if __name__ == '__main__':
#     rospy.init_node('grid_gene', anonymous=True)
#     cred = credentials.Certificate("/home/maria/Downloads/agri-pro-ae630-firebase-adminsdk-cc1eu-067e252c88.json")
#     firebase_admin.initialize_app(cred, {"databaseURL": "https://agri-pro-ae630-default-rtdb.firebaseio.com/"})
    
#     ref = db.reference("/")
    
#     rospy.Subscriber("/chosen_area_lon", Float32MultiArray, lonCallback)
#     rospy.Subscriber("/chosen_area_lat", Float32MultiArray, latCallback)
#     rospy.Subscriber("/mavros/global_position/global",NavSatFix,curPoseCallback)
#     curlat = 0.0
#     curlon =0.0
#     # Wait for topics to populate variables
#     while lat1 == 0.0 or lon1 == 0.0 or lat2 == 0.0 or lon2 == 0.0 or lat3 == 0.0 or lon3 == 0.0 or lat4 == 0.0 or lon4 == 0.0 or curlat==0.0 or curlon ==0.0:
#         rospy.sleep(0.1)
    
#     interval = 2  # interval in meters
#     global alt
#     alt = 2.000000
    
#     # Generate the waypoints grid
#     waypoints_grid = generate_waypoints_grid(lat1, lon1, lat2, lon2, lat3, lon3, lat4, lon4, interval)
#     filename = "/home/maria/droneway.txt"
#     save_waypoints(filename,waypoints_grid)
#     uptoFb(waypoints_grid,ref)
#     #print(waypoints_grid)
#     rospy.spin()

#####################################################
# def haversine(lat1, lon1, lat2, lon2):
#     R = 6371000  # Radius of the Earth in meters
#     lat1 = math.radians(lat1)
#     lon1 = math.radians(lon1)
#     lat2 = math.radians(lat2)
#     lon2 = math.radians(lon2)
#     dlat = lat2 - lat1
#     dlon = lon2 - lon1
#     a = math.sin(dlat / 2)**2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon / 2)**2
#     c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
#     distance = R * c
#     return distance

# def calculate_bearing(lat1, lon1, lat2, lon2):
#     dlon = math.radians(lon2 - lon1)
#     lat1 = math.radians(lat1)
#     lat2 = math.radians(lat2)
#     x = math.sin(dlon) * math.cos(lat2)
#     y = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dlon)
#     bearing = math.atan2(x, y)
#     return bearing

# def generate_waypoints_grid(lat1, lon1, lat2, lon2, lat3, lon3, lat4, lon4, interval):
#     waypoints = []

#     # Calculate the distances and bearings
#     bottom_distance = haversine(lat1, lon1, lat2, lon2)
#     left_distance = haversine(lat1, lon1, lat4, lon4)
#     bottom_bearing = calculate_bearing(lat1, lon1, lat2, lon2)
#     left_bearing = calculate_bearing(lat1, lon1, lat4, lon4)
    
#     # Convert lat/lon to radians
#     lat1 = math.radians(lat1)
#     lon1 = math.radians(lon1)

#     num_rows = int(left_distance // interval) + 1
#     num_cols = int(bottom_distance // interval) + 1

#     for i in range(num_rows):
#         row = []
#         for j in range(num_cols):
#             d_vert = interval * i / 6371000  # interval in meters divided by Earth's radius in meters
#             d_horiz = interval * j / 6371000

#             # Calculate latitude and longitude for vertical movement
#             lat_vert = math.asin(math.sin(lat1) * math.cos(d_vert) + math.cos(lat1) * math.sin(d_vert) * math.cos(left_bearing))
#             lon_vert = lon1 + math.atan2(math.sin(left_bearing) * math.sin(d_vert) * math.cos(lat1), math.cos(d_vert) - math.sin(lat1) * math.sin(lat_vert))

#             # Calculate latitude and longitude for horizontal movement from the vertical position
#             lat_i = math.asin(math.sin(lat_vert) * math.cos(d_horiz) + math.cos(lat_vert) * math.sin(d_horiz) * math.cos(bottom_bearing))
#             lon_i = lon_vert + math.atan2(math.sin(bottom_bearing) * math.sin(d_horiz) * math.cos(lat_vert), math.cos(d_horiz) - math.sin(lat_vert) * math.sin(lat_i))

#             # Convert back to degrees
#             lat_i = math.degrees(lat_i)
#             lon_i = math.degrees(lon_i)

#             row.append((lat_i, lon_i))
        
#         if i % 2 == 1:  # Reverse every other row for snake-like ordering
#             row.reverse()
        
#         waypoints.extend(row)
#         print(waypoints)
#     return waypoints


#!/usr/bin/env python3
import firebase_admin
from firebase_admin import credentials, db
import math
import rospy
from std_msgs.msg import Float32MultiArray
from sensor_msgs.msg import NavSatFix
import os

import subprocess
# Global variables to store latitudes and longitudes
lat1 = lon1 = lat2 = lon2 = lat3 = lon3 = lat4 = lon4 = 0.0
curlat = curlon = 0.0
alt = 2.0  # Altitude
flagg = 1

# def haversine(lat1, lon1, lat2, lon2):
#     R = 6371000  # Radius of the Earth in meters
#     phi1, phi2 = math.radians(lat1), math.radians(lat2)
#     delta_phi = phi2 - phi1
#     delta_lambda = math.radians(lon2 - lon1)
#     a = math.sin(delta_phi / 2)**2 + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2)**2
#     c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
#     return R * c

# def generate_grid(lat1, lon1, lat2, lon2, lat3, lon3, lat4, lon4, interval):
#     corners = [(lat1, lon1), (lat2, lon2), (lat3, lon3), (lat4, lon4)]
#     num_rows = int(haversine(lat1, lon1, lat3, lon3) / interval) + 1
#     num_cols = int(haversine(lat1, lon1, lat2, lon2) / interval) + 1
    
#     # corners are given in the order: [bottom_left, bottom_right, top_left, top_right]
#     # Calculate grid spacing based on the average height and width in meters
#     bottom_width = haversine(corners[0][0], corners[0][1], corners[1][0], corners[1][1])
#     left_height = haversine(corners[0][0], corners[0][1], corners[2][0], corners[2][1])
#     row_interval = left_height / (num_rows - 1)
#     col_interval = bottom_width / (num_cols - 1)
    
#     grid = []
#     for i in range(num_rows):
#         row = []
#         for j in range(num_cols):
#             # Calculate point using linear interpolation of latitudes and longitudes
#             start_lat = corners[0][0] + (corners[2][0] - corners[0][0]) * (i / (num_rows - 1))
#             start_lon = corners[0][1] + (corners[2][1] - corners[0][1]) * (i / (num_rows - 1))
#             end_lat = corners[1][0] + (corners[3][0] - corners[1][0]) * (i / (num_rows - 1))
#             end_lon = corners[1][1] + (corners[3][1] - corners[1][1]) * (i / (num_rows - 1))

#             lat = start_lat + (end_lat - start_lat) * (j / (num_cols - 1))
#             lon = start_lon + (end_lon - start_lon) * (j / (num_cols - 1))

#             row.append((lat, lon))
#         grid.append(row)
    
#     return [waypoint for row in grid for waypoint in row]

def haversine(lat1, lon1, lat2, lon2):
    R = 6371000  # Radius of the Earth in meters
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    delta_phi = phi2 - phi1
    delta_lambda = math.radians(lon2 - lon1)
    a = math.sin(delta_phi / 2)**2 + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c

def generate_grid(lat1, lon1, lat2, lon2, lat3, lon3, lat4, lon4, interval):
    corners = [(lat1, lon1), (lat2, lon2), (lat3, lon3), (lat4, lon4)]
    num_rows = int(haversine(lat1, lon1, lat3, lon3) / interval) + 1
    num_cols = int(haversine(lat1, lon1, lat2, lon2) / interval) + 1
    
    # corners are given in the order: [bottom_left, bottom_right, top_left, top_right]
    # Calculate grid spacing based on the average height and width in meters
    bottom_width = haversine(corners[0][0], corners[0][1], corners[1][0], corners[1][1])
    left_height = haversine(corners[0][0], corners[0][1], corners[2][0], corners[2][1])
    row_interval = left_height / (num_rows - 1)
    col_interval = bottom_width / (num_cols - 1)
    print("nummmm of rows")
    print(num_rows)
    grid = []
    for i in range(num_rows):
        row = []
        for j in range(num_cols):
            # Calculate point using linear interpolation of latitudes and longitudes
            start_lat = corners[0][0] + (corners[2][0] - corners[0][0]) * (i / (num_rows - 1))
            start_lon = corners[0][1] + (corners[2][1] - corners[0][1]) * (i / (num_rows - 1))
            end_lat = corners[1][0] + (corners[3][0] - corners[1][0]) * (i / (num_rows - 1))
            end_lon = corners[1][1] + (corners[3][1] - corners[1][1]) * (i / (num_rows - 1))

            lat = start_lat + (end_lat - start_lat) * (j / (num_cols - 1))
            lon = start_lon + (end_lon - start_lon) * (j / (num_cols - 1))

            row.append((lat, lon))
        
        # Reverse every other row to create snake-like pattern
        if i % 2 == 1:
            row.reverse()
        
        grid.append(row)
        
    
    return [waypoint for row in grid for waypoint in row]




def lonCallback(msg):
    global lon1, lon2, lon3, lon4
    arr = msg.data
    lon1 = arr[0]
    lon2 = arr[1]
    lon3 = arr[2]
    lon4 = arr[3]

def latCallback(msg):
    global lat1, lat2, lat3, lat4
    arr = msg.data
    lat1 = arr[0]
    lat2 = arr[1]
    lat3 = arr[2]
    lat4 = arr[3]

def curPoseCallback(msg):
    global curlat, curlon
    curlat = msg.latitude
    curlon = msg.longitude

def save_waypoints(filename, waypoints):
    global flagg
    if os.path.exists(filename):
        os.remove(filename)
    with open(filename, 'w') as f:
        f.write('QGC WPL 110\n')
        f.write(f"{0}\t1\t0\t16\t0.000000\t0.000000\t0.000000\t0.000000\t{curlat:.8f}\t{curlon:.8f}\t{alt:.8f}\t1\n")
        f.write(f"{1}\t0\t3\t22\t0.000000\t0.000000\t0.000000\t0.000000\t{curlat:.8f}\t{curlon:.8f}\t{alt:.8f}\t1\n")
        for i, (lat, lon) in enumerate(waypoints):
            f.write(f"{i+2}\t0\t3\t16\t0.000000\t0.000000\t0.000000\t0.000000\t{lat:.8f}\t{lon:.8f}\t{alt:.8f}\t1\n")
        f.write(f"{i+3}\t0\t0\t21\t0.000000\t0.000000\t0.000000\t0.000000\t{curlat:.8f}\t{curlon:.8f}\t{alt:.8f}\t1\n")
    rospy.sleep(0.5)
    if flagg ==1:
        subprocess.Popen(["rosrun", "mavros_py", "takeoff_land.py"])
        flagg=0
def uptoFb(waypoints, ref):
    ref.child("waypoints").delete()
    ref.child(f"waypoints/waypoint{0:03}/latitude").set(curlat)
    ref.child(f"waypoints/waypoint{0:03}/longitude").set(curlon)
    for i, (lat, lon) in enumerate(waypoints):
        ref.child(f"waypoints/waypoint{i+1:03}/latitude").set(lat)
        ref.child(f"waypoints/waypoint{i+1:03}/longitude").set(lon)
        rospy.sleep(0.5)
    ref.child(f"waypoints/waypoint{i+2:03}/latitude").set(curlat)
    ref.child(f"waypoints/waypoint{i+2:03}/longitude").set(curlon)

if __name__ == '__main__':
    rospy.init_node('grid_gene', anonymous=True)
    cred = credentials.Certificate("/home/maria/Downloads/agri-pro-ae630-firebase-adminsdk-cc1eu-067e252c88.json")
    firebase_admin.initialize_app(cred, {"databaseURL": "https://agri-pro-ae630-default-rtdb.firebaseio.com/"})
    
    ref = db.reference("/")
    
    rospy.Subscriber("/chosen_area_lon", Float32MultiArray, lonCallback)
    rospy.Subscriber("/chosen_area_lat", Float32MultiArray, latCallback)
    rospy.Subscriber("/mavros/global_position/global", NavSatFix, curPoseCallback)
    
    # Wait for topics to populate variables
    while lat1 == 0.0 or lon1 == 0.0 or lat2 == 0.0 or lon2 == 0.0 or lat3 == 0.0 or lon3 == 0.0 or lat4 == 0.0 or lon4 == 0.0 or curlat == 0.0 or curlon == 0.0:
        rospy.sleep(0.1)
    
    interval = 2  # interval in meters
    
    # Generate the waypoints grid
    waypoints_grid = generate_grid(lat1, lon1, lat2, lon2, lat3, lon3, lat4, lon4, interval)
    filename = "/home/maria/droneway.txt"
    save_waypoints(filename, waypoints_grid)
    uptoFb(waypoints_grid, ref)
    
    rospy.spin()
