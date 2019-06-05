import serial
import time
from cv2 import *
import sys

cam = VideoCapture(0)   # 0 -> index of camera
i =0
slash='\\'
ser = serial.Serial ("COM5", 115200)    #Open port with baud rate
while True:
    received_data = ser.read()              #read serial port
    time.sleep(1)
    data_left = ser.inWaiting()             #check for remaining byte
    received_data += ser.read(data_left)
    test = received_data.decode("utf-8")
    print (test) 
    #"                  #print received data
  # ''' if received_data == a:
   #     print("ah be abi")
   # else:
        #print(a )
        #print("! = ")
    #    print( received_data[0])'''
    if test == "data" :
        print(str(i)+test)
        s, img = cam.read()
        if s:    # frame captured without any errors
            #namedWindow("cam-test",cv2.WINDOW_NORMAL)
            #imshow("cam-test",img)
            #waitKey(0)
            #destroyWindow("cam-test")
            written = "filename"+ str(i) + ".jpg"
            imwrite(written,img) #save image
            i = i+1
    elif test == "datas":
        sys.exit("Thanks for using UART :)")

    ser.write(received_data)