from PIL import Image
from PIL import ImageGrab
import numpy as np
import os
import socket
import sys
import time
from numba import jit

def process_vectorized(binary_array):
        # split binary array into r, g, b arrays
        r = binary_array[:,:,0]
        g = binary_array[:,:,1]
        b = binary_array[:,:,2]

        #x = (r << 8) | g | (b << 4) # u tohodle jsem si na 15% jistej, ze to funguje
        x = np.bitwise_or(np.left_shift(r, 8), np.bitwise_or(g, np.left_shift(b, 4, dtype=np.uint16), dtype=np.uint16), dtype=np.uint16)

        # premyslim, jestli x neni nahodou pole uint8 a jestli se tady neztraci jeden kanal barevnej
        # protoze  binary_array = np.zeros_like(img_array, dtype=np.uint8)  - vyřešeno ne? 

        # tady teda asi nejak potrebujeme to poskladat do toho pole po 12 bitech za sebou..

        return x
        ## funguje to? :D snad 



host = "192.168.1.15"  # Change this to the destination host
port = 81         # Change this to the destination port

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.SO_SNDBUF, 65536)
sock.settimeout(50)

rowlen = 400


outputValue = np.zeros(rowlen, dtype=np.uint16)






screenshot = ImageGrab.grab()


start_time = time.perf_counter()

    # Convert image to a NumPy array
img_array = np.array(screenshot)

# Convert each channel to 12-bit binary representation (0 to 4095) ignore last element
binary_array = np.zeros_like(img_array, dtype=np.uint16)  # Use uint16 for 16-bit integers



binary_array = img_array >> 4

binary_array[:, :, 0] = 255
binary_array[:, :, 1] = 255
binary_array[:, :, 2] = 255


x = process_vectorized(binary_array)
end_time = time.perf_counter()

print("type: ", x.dtype)
print("max: ", x.max())
print(x)
print("FPS: ", 1/(end_time - start_time))
print("Screenshot  time: ", end_time - start_time)

