#!/usr/bin/env python3
import firebase_admin
from firebase_admin import credentials, db
import rospy
import signal
import sys
from std_msgs.msg import Float32MultiArray
# from mavros_py.msg import FloatPairArray
from sensor_msgs.msg import NavSatFix

def on_data_change(event):
    """
    Callback function triggered by a change in the Firebase Realtime Database.
    """
    print(f"Event type: {event.event_type}")  # Can be 'put' or 'patch'
    print(f"Path: {event.path}")  # The path to the updated location
    print(f"Data: {event.data}")  # The new data at the location
    
    # Process the data as needed
    if "chosen_places" in event.path:
        chosen_places_data = event.data
    
        arrlat.append(chosen_places_data['latitude'])
        arrlon.append(chosen_places_data['longitude'])
            
        # arr.append(i.value, j.value)
        print(arrlat)
        print(len(arrlat))
    else:
        print("chosen_places node not found in the database.")

    if len(arrlat) == 4:
        print(arrlat)
        print(arrlon)
        for i in range(len(arrlat)):
            msglat.data.append(arrlat[i])
            msglon.data.append(arrlon[i])
        
        publat.publish(msglat)
        publon.publish(msglon)

def firebase_listener():
    """
    Initialize Firebase app and set up a listener on the chosen_places node.
    """
    global listener
    cred = credentials.Certificate("/home/maria/Downloads/agri-pro-ae630-firebase-adminsdk-cc1eu-067e252c88.json")
    firebase_admin.initialize_app(cred, {"databaseURL": "https://agri-pro-ae630-default-rtdb.firebaseio.com/"})
    
    ref = db.reference("/")
    ref.child("chosen_places").delete()
    ref.child("location/latitude").set(curlat)
    ref.child("location/longitude").set(curlon)
    rospy.sleep(1)
    listener = ref.listen(on_data_change)

def signal_handler(sig, frame):
    """
    Handle the SIGINT signal to gracefully shutdown.
    """
    print("Shutting down gracefully...")
    listener.close()
    rospy.signal_shutdown("SIGINT received")
    sys.exit(0)

def curPoseCallback(msg):
    fl = 1
    global curlat
    
    global curlon 
    
    if fl == 1:
        curlat = msg.latitude
        curlon = msg.longitude
        fl = 0
if __name__ == '__main__':
    rospy.init_node('firebase_reader_node', anonymous=True)

    signal.signal(signal.SIGINT, signal_handler)
    global publat
    global publon
    arrlat = []
    arrlon =[]
    msglat = Float32MultiArray()
    msglon = Float32MultiArray()
    curlat = 0.0
    curlon = 0.0
    global fl 
    
    
    
    publat = rospy.Publisher('chosen_area_lat',Float32MultiArray , queue_size=10)
    publon = rospy.Publisher('chosen_area_lon',Float32MultiArray , queue_size=10)
    rospy.Subscriber("/mavros/global_position/global",NavSatFix,curPoseCallback)
    while curlat == 0.0 or curlon == 0.0 :
        rospy.sleep(0.1)
    
    firebase_listener()
    rospy.spin()
