#!/usr/bin/env python3

import rospy
from mavros_msgs.srv import SetMode
from mavros_msgs.srv import CommandBool
from mavros_msgs.srv import CommandTOL
from geometry_msgs.msg import PoseStamped
import subprocess
pid = 0
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
    
def armed():
    rospy.wait_for_service('/mavros/cmd/arming')
    try:
        arming = rospy.ServiceProxy('/mavros/cmd/arming', CommandBool)
        print("arming uuuuu : ",arming)
        response = arming(value=1)
        
        print("arm")
        rospy.loginfo("drone arming %s", response)

    except rospy.ServiceException as e:
        rospy.logerr("Failed to call service: %s", str(e))
        return False
    
def takeoff(meter):
    rospy.wait_for_service('/mavros/cmd/takeoff')
    try:
        tkoff = rospy.ServiceProxy('/mavros/cmd/takeoff', CommandTOL)
        print("arming uuuuu : ",tkoff)
        response = tkoff(altitude=meter)
        print("takeoff")
        rospy.loginfo("drone takeoff %s", response)
        rospy.sleep(3)
        if response.success:
            subprocess.Popen(["roslaunch", "mavros_py", "navimg.launch"])
        return response.success
          
    except rospy.ServiceException as e:
        rospy.logerr("Failed to call service: %s", str(e))
        return False
    
def poseCallback(msg):
    global pose 
    global pid; pid =0
    pose = msg.pose.position.z
    if abs(pose - target_altitude) < altitude_tolerance:
        pid = 1
          

if __name__ == "__main__":
    rospy.init_node('set_flight_mode_node')
    rospy.Subscriber("/mavros/local_position/pose",PoseStamped,poseCallback)
    mode = "GUIDED" 
    altitude_tolerance = 0.5
    target_altitude = 2.0  
    success = set_flight_mode(mode)

    print("suc : ",success)
    if success.mode_sent:
        armed()
        rospy.sleep(1.0)
        takeoff(target_altitude)
        print(pid)
        
            
        # while not pid:
        #     print(pid)
        #     rospy.sleep(0.1)
            
        # else :
        #     print(pid)
        #     #set_flight_mode("LAND")
            
        rospy.loginfo("Successfully set flight mode to %s", mode)
    else:
        rospy.logerr("Failed to set flight mode to %s", mode)
    rospy.spin()

