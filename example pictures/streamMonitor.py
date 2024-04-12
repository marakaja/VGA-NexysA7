from PIL import Image
from PIL import ImageGrab
import numpy as np
import os
import socket
import sys
import time

def process_vectorized(binary_array):
    # split binary array into r, g, b arrays
    r = binary_array[:,:,0]
    g = binary_array[:,:,1]
    b = binary_array[:,:,2]

    #x = r << 8 | g | b << 4 # u tohodle jsem si na 15% jistej, ze to funguje
    #x = np.bitwise_or(np.left_shift(r, 8), np.bitwise_or(g, np.left_shift(b, 4)), dtype=np.uint16)

    #final order G R
    #x = np.uint16(np.left_shift(g, 8, dtype=np.uint16) | np.uint16(r) | np.left_shift(b, 4))
    x = np.uint16(np.left_shift(g, 8, dtype=np.uint16) | np.uint16(r) | np.left_shift(b, 12, dtype=np.uint16))
    
    return x

host = "192.168.1.15"  # Change this to the destination host
port = 81         # Change this to the destination port
packetSize = 400

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, 65000)  # Buffer size MAX
sock.settimeout(5)

rowlen = 400    
collen = 300

screenshot = ImageGrab.grab().resize((rowlen, collen))

# Convert image to a NumPy array
img_array = np.array(screenshot)

# Convert each channel to 12-bit binary representation (0 to 4095) ignore last element
binary_array = np.zeros_like(img_array, dtype=np.uint8)  

byteStream = bytearray(b'\x00'*rowlen*collen*2)

while True:
    start_time = time.perf_counter()

    screenshot = ImageGrab.grab().resize((rowlen, collen))

    # Convert image to a NumPy array
    img_array = np.array(screenshot)

    img_array = img_array >> 4
    

    colorMap = process_vectorized(img_array)

    byteStream = colorMap.tobytes()

    for i in range(0, len(byteStream), packetSize*2):
        addr = int(i/2).to_bytes(5, byteorder='little')
        buf = addr + byteStream[i:i+packetSize*2]


        #sock.sendto(buf, (host, port))
    
  
    end_time = time.perf_counter()

    print("FPS: ", 1/(end_time - start_time))
