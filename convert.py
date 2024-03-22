from PIL import Image
import numpy as np
import os

def png_to_binary_12bit(image_path):
  """Converts a PNG image to a 12-bit binary representation of its pixels.

  Args:
      image_path: Path to the PNG image file.

  Returns:
      A NumPy array containing the 12-bit binary representation of the image pixels.
  """






# Get the image path from the user
image_path = input("Enter the path to your PNG image: ")

# Open the image
img = Image.open(image_path)

  # Convert image to a NumPy array
img_array = np.array(img)

#Remove alpha channel if it exists
if img_array.shape[2] > 3:
  img_array = img_array[:, :, :3]



# Convert each channel to 12-bit binary representation (0 to 4095) ignore last element
binary_array = np.zeros_like(img_array, dtype=np.uint16)  # Use uint16 for 16-bit integers
print(binary_array)

for i in range(3):  # Loop over each channel (R, G, B)
  binary_array[:, :, i] = img_array[:, :, i] >> 4  # Shift 4 bits to the right to get 12-bit binary representation


# Save the binary array to a file as C array of 16-bit integers in hex format 0xFFFF
output_path = os.path.splitext(image_path)[0] + ".h"
file_coef = open(os.path.splitext(image_path)[0] + ".coe","w")  #create a new coefficient file
file_coef.write("memory_initialization_radix=10;\n")
file_coef.write("memory_initialization_vector=\n")
with open(output_path, "w") as file:
  file.write("const uint16_t image[] = {")
  for row in binary_array:
    for pixel in row:
      outputValue = (pixel[0] << 8) | pixel[1] | (pixel[2] << 4)
      #write value in binary to file in C array format
      file.write(f"0x{outputValue:04X}, ")
      file_coef.write(f"{outputValue},\n")
      
    file.write("\n")
  file.write("};")

  


print("Image converted to 12-bit binary representation and saved to file.")






