#!/usr/bin/env python
import rospy
from mavros_msgs.msg import WaypointReached
import firebase_admin
from firebase_admin import credentials, storage
import cv2
from cv_bridge import CvBridge
from sensor_msgs.msg import Image

def initialize_firebase(credentials_path):
    cred = credentials.Certificate(credentials_path)
    app = firebase_admin.initialize_app(cred, {
        'storageBucket': 'agri-pro-ae630.appspot.com'},
        name='storage')
    return storage.bucket(app=app)

def upload_image_to_firebase(image_path, wp, bucket):
    if wp != 0.0 and wp < 10:
        blob = bucket.blob(f'0{wp-2}.jpg')
    else:
        blob = bucket.blob(f'{wp-2}.jpg')
    blob.upload_from_filename(image_path)
    rospy.loginfo("Image uploaded to Firebase")

def image_callback(msg, bucket):
    global flg, wp
    if flg == 1:
        bridge = CvBridge()
        try:
            # Convert ROS Image message to OpenCV image
            current_frame = bridge.imgmsg_to_cv2(msg, desired_encoding='bgr8')
        except Exception as e:
            rospy.logerr("Failed to convert image %s" % e)
            return

        # Save the image locally
        cv2.imwrite('current_frame.jpg', current_frame)
        rospy.loginfo("Saved image current_frame.jpg")

        # Upload image to Firebase
        upload_image_to_firebase('current_frame.jpg', wp, bucket)
        flg = 0

def imgFb(msg):
    global flg, wp
    wp = msg.wp_seq
    rospy.loginfo(f"Waypoint reached: {wp}")
    if wp > 2:
        flg = 1


if __name__ == '__main__':
    rospy.init_node('image_fb', anonymous=True)
    global flg, wp
    wp = 0.0
    flg = 0
    credentials_path = "/home/maria/Downloads/agri-pro-ae630-firebase-adminsdk-cc1eu-067e252c88.json"
    bucket = initialize_firebase(credentials_path)

    
    rospy.Subscriber('/webcam/image_raw', Image, lambda msg: image_callback(msg, bucket))
    rospy.Subscriber("/mavros/mission/reached", WaypointReached, imgFb)
    rospy.spin()
