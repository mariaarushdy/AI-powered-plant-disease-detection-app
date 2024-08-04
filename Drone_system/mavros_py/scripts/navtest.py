#!/usr/bin/env python
import rospy
import csv
from mavros_msgs.srv import WaypointPush
from mavros_msgs.msg import Waypoint
from mavros_msgs.srv import SetMode
from sensor_msgs.msg import NavSatFix
import firebase_admin
from firebase_admin import credentials, db
from geometry_msgs.msg import PoseStamped

curlat = 0.0
curlon = 0.0
fl = 0

def read_waypoints_from_file(filename):
    waypoints = []
    with open(filename, 'r') as csvfile:
        waypoint_reader = csv.reader(csvfile, delimiter='\t')
        next(waypoint_reader)  # Skip the header line
        for row in waypoint_reader:
            if len(row) != 12:
                rospy.logwarn("Skipping malformed line: %s", row)
                continue
            waypoint = Waypoint()
            waypoint.frame = int(row[2])
            waypoint.command = int(row[3])
            waypoint.is_current = bool(int(row[1]))
            waypoint.autocontinue = bool(int(row[11]))
            waypoint.param1 = float(row[4])
            waypoint.param2 = float(row[5])
            waypoint.param3 = float(row[6])
            waypoint.param4 = float(row[7])
            waypoint.x_lat = float(row[8])
            waypoint.y_long = float(row[9])
            waypoint.z_alt = float(row[10])
            waypoints.append(waypoint)
    return waypoints

def upload_waypoints(waypoints):
    rospy.wait_for_service('/mavros/mission/push')
    try:
        push_service = rospy.ServiceProxy('/mavros/mission/push', WaypointPush)
        response = push_service(start_index=0, waypoints=waypoints)
        return response.success
    except rospy.ServiceException as e:
        rospy.logerr("Service call failed: %s" % e)
        return False

def set_flight_mode(mode):
    rospy.wait_for_service('/mavros/set_mode')
    try:
        set_mode = rospy.ServiceProxy('/mavros/set_mode', SetMode)
        response = set_mode(custom_mode=mode)
        rospy.loginfo("Flight mode set to: %s", mode)
        return response
    except rospy.ServiceException as e:
        rospy.logerr("Failed to call service: %s", str(e))
        return False

def curPoseCallback(msg):
    global curlat
    global curlon
    global fl

    if fl == 1:
        curlat = msg.latitude
        curlon = msg.longitude
        ref.child("location/latitude").set(curlat)
        ref.child("location/longitude").set(curlon)
        
# def curPoseCallback(msg):
#     global curlat
#     global curlon
#     global fl

#     if fl == 1:
#         curlat = msg.latitude
#         curlon = msg.longitude

# def sendLocation(event):
#     global curlat
#     global curlon

#     if curlat is not None and curlon is not None:
#         ref.child("location/latitude").set(curlat)
#         ref.child("location/longitude").set(curlon)
    
def currAlt(msg):
    global ref
    alt = msg.pose.position.z
    if alt <= 0:
        ref.child("chosen_places").delete()

def main():
    rospy.init_node('waypoint_loader', anonymous=True)
    
    global fl
    filename = '/home/maria/droneway.txt'  # Replace with your waypoints file
    waypoints = read_waypoints_from_file(filename)
    if upload_waypoints(waypoints):
        rospy.loginfo("Waypoints uploaded successfully")
        rospy.sleep(0.5)
        set_flight_mode("auto")
        fl = 1
    else:
        rospy.logerr("Failed to upload waypoints")

if __name__ == '__main__':
    cred = credentials.Certificate("/home/maria/Downloads/agri-pro-ae630-firebase-adminsdk-cc1eu-067e252c88.json")
    firebase_admin.initialize_app(cred, {"databaseURL": "https://agri-pro-ae630-default-rtdb.firebaseio.com/"})
    
    ref = db.reference("/")
    rospy.Subscriber("/mavros/global_position/global", NavSatFix, curPoseCallback)
    rospy.Subscriber("/mavros/local_position/pose",PoseStamped,currAlt)
    # rospy.Timer(rospy.Duration(0.5), sendLocation)
    main()
    rospy.spin()


# 1	0	3	16	0.000000	0.000000	0.000000	0.000000	-35.36326220	149.16523750	2.00000000	1
# 2	0	3	16	0.000000	0.000000	0.000000	0.000000	-35.36336136	149.16519165	2.00000000	1
# 3	0	3	16	0.000000	0.000000	0.000000	0.000000	-35.36335384	149.16521169	2.00000000	1
# 4	0	3	16	0.000000	0.000000	0.000000	0.000000	-35.36336203	149.16523133	2.00000000	1
# 5	0	3	16	0.000000	0.000000	0.000000	0.000000	-35.36336954	149.16521129	2.00000000	1
# 6	0	3	16	0.000000	0.000000	0.000000	0.000000	-35.36337773	149.16523093	2.00000000	1
# 7	0	3	16	0.000000	0.000000	0.000000	0.000000	-35.36337021	149.16525097	2.00000000	1
# 8	0	0	21	0.000000	0.000000	0.000000	0.000000	-35.36326220	149.16523750	2.00000000	1