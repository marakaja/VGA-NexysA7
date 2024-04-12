from PIL import Image
import numpy as np
import os
import socket
import sys

host = "192.168.1.15"  # Change this to the destination host
port = 81         # Change this to the destination port

# Get the image path from the user
#image_path = input("Enter the path to your PNG image: ")
image_path = sys.argv[1]

# Open the image
img = Image.open(image_path)

  # Convert image to a NumPy array
img_array = np.array(img)


#Remove alpha channel if it exists
if img_array.shape[2] > 3:
  img_array = img_array[:, :, :3]

print(f"Image shape: {img_array.shape}")
print(f"Image data type: {img_array.dtype}")
print(f"Image firt pixel: {img_array[0, 0]}")



# Convert each channel to 12-bit binary representation (0 to 4095) ignore last element
binary_array = np.zeros_like(img_array, dtype=np.uint16)  # Use uint16 for 16-bit integers


for i in range(3):  # Loop over each channel (R, G, B)
  binary_array[:, :, i] = img_array[:, :, i] >> 4  # Shift 4 bits to the right to get 12-bit binary representation


i = 0
for row in binary_array:
    binary_row = b''
    for pixel in row:
        outputValue = (pixel[0] << 8) | pixel[1] | (pixel[2] << 4)
        binary_row = b''.join([binary_row, int(outputValue).to_bytes(2, byteorder='big')])
    addr = i * 400
    addr = int(addr).to_bytes(5, byteorder='little')
    binary_row = b''.join([addr, binary_row])

    try:
        # Create a UDP socket
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
            # Send the message
            sock.settimeout(50)
            sock.sendto(binary_row, (host, port))
    except Exception as e:
        print(f"Error occurred: {e}")
    i += 1