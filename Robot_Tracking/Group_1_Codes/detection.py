'''
Topic: Tracking using QR codes
Members:
    --> Prasita Mukherjee(174101042)
    --> Akhilesh Yadav(174101020)
    --> Md. Zaki Anwer(174101030)
    --> Divyam Lamiyan(174101002)
'''


import cv2
import zbar
from PIL import Image

cv2.namedWindow("Tracking")

cap = cv2.VideoCapture(0)

scanner = zbar.ImageScanner()
scanner.parse_config('enable')

# variables for tracking with exponential averaging
alpha=0.3 #smoothing factor should be b/w 0 and 1  
store={}
pred={}
qrc=[]  # list of calibrated qr codes

# calibration for tracking with exponential averaging 
def calibration():
    print("Place all qr codes and press ESC when done")
    while True:
        ret, output = cap.read()
        if not ret:
          continue
        gray = cv2.cvtColor(output, cv2.COLOR_BGR2GRAY, dstCn=0)
        pil = Image.fromarray(gray)
        width, height = pil.size
        raw = pil.tobytes()
        image = zbar.Image(width, height, 'Y800', raw)
        scanner.scan(image)
        f= open("data.txt","w")
        #colour=[(255,0,0),(0,128,0),(0,0,255),(0,0,0)]

        for symbol in image:
            if symbol.data not in pred:
                pred[symbol.data]=symbol.location
                qrc.append(symbol.data) 

        
        cv2.imshow("Tracking", output)
        k = cv2.waitKey(1) & 0xff
        if k == 27 : break

# tracking without exponential averaging 
# it doesn't require calibration
def tracking():
    while True:
        ret, output = cap.read()
        if not ret:
          continue
        gray = cv2.cvtColor(output, cv2.COLOR_BGR2GRAY, dstCn=0)
        pil = Image.fromarray(gray)
        width, height = pil.size
        raw = pil.tobytes()
        image = zbar.Image(width, height, 'Y800', raw)
        scanner.scan(image)
        # open file to write information about qrcode
        f= open("data.txt","w")
        #write in the file
        for symbol in image:
            f.write(str(symbol.data)+"\n")
            (x1,y1)=symbol.location[0]
            (x2,y2)=symbol.location[1]
            (x3,y3)=symbol.location[2]
            (x4,y4)=symbol.location[3]
            (X,Y)=((x1+x2+x3+x4)/4,(y1+y2+y3+y4)/4)
            f.write(str(X)+" "+str(Y)+"\n")
            n=len(symbol.location)
            for j in range(0,n):
                cv2.line(output, symbol.location[j], symbol.location[ (j+1) % n], (0,0,255), 2)

        cv2.imshow("Tracking", output)

        # Wait for the magic key
        k = cv2.waitKey(1) & 0xff
        if k == 27 : break

# tracking with exponential averaging
# it requires calibration
def tracking_with_exp():
    while True:
        ret, output = cap.read()
        if not ret:
          continue
        gray = cv2.cvtColor(output, cv2.COLOR_BGR2GRAY, dstCn=0)
        pil = Image.fromarray(gray)
        width, height = pil.size
        raw = pil.tobytes()
        image = zbar.Image(width, height, 'Y800', raw)
        scanner.scan(image)

        # open file to write information about qrcode
        f= open("data.txt","w")

        for symbol in image:
            store[symbol.data]=symbol.location        
        
        # apply exponential averaging
        for i in range(0,len(qrc)):
            if qrc[i] not in store:
                store[qrc[i]]=pred[qrc[i]]
            temp=[]
            cnt=0
            list=pred[qrc[i]]
            for (x,y) in store[qrc[i]]:
                (a,b)=list[cnt]
                temp.append((alpha*x+(1-alpha)*a,alpha*y+(1-alpha)*b))
                cnt=cnt+1
            pred[qrc[i]]=temp

        #write in the file
        for sym in store:
            f.write(str(sym)+"\n")
            cor=store[sym]
            (x1,y1)=cor[0]
            (x2,y2)=cor[1]
            (x3,y3)=cor[2]
            (x4,y4)=cor[3]
            (X,Y)=((x1+x2+x3+x4)/4,(y1+y2+y3+y4)/4)
            f.write(str(X)+" "+str(Y)+"\n")
            n=len(cor)
            for j in range(0,n):
                cv2.line(output, cor[j], cor[(j+1)% n], (0,0,255), 2)

        cv2.imshow("Tracking", output)

        k = cv2.waitKey(1) & 0xff
        if k == 27 : break            

# call calibration() and tracking_with_exp() for tracking with exponential averaging        
calibration()
tracking_with_exp()

# call just tracking() for normal tracking
#tracking()

# When everything is done, release the capture
cap.release()
cv2.destroyAllWindows()
