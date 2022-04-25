#!/usr/bin/python

import sys

lstFile = sys.argv[1]
memory_name  = sys.argv[2]
total_width = int(sys.argv[3])
memory_width =  int(sys.argv[4])
memory_depth =  int(sys.argv[5])
total_bytes =  int(sys.argv[6])

#lstFile = "reg32sanity.lst"
#memory_name = "rom_control"
#total_width = 128
#memory_width = 32
#memory_depth = 32
#total_bytes = 4096

test_name = sys.argv[7]

def hexTobin(hex, bits) :
   return bin(int(hex, 16))[2:].zfill(bits)

# Create hex View of Program
hexArray = ["ZZ"] * 4096

f = open(lstFile, "r")
lines = f.readlines()

count = 0
for line in lines:
   print("Converting: " + line);
   if (line != '\n' and line[0] != "/"):
      string = line.strip().replace(' ', '')
      colon_split = string.split(":")

      address = colon_split[0].split("x")[1]
      bin_address = int(address,16)

      command_hex =  colon_split[1].split("//")[0]
      comment =   colon_split[1].split("//")[1]

      offset = 0;
      hex_list = [];

      for index in range(0, len(command_hex), 2):
         hex_list.append(command_hex[index : index + 2])

      for byte in hex_list:
         hexArray[bin_address + offset] = byte
         offset += 1
    
      print("Out: ", bin_address, command_hex);

f = open("./test_generation/"+test_name+"_readable", "w")

# Create readable file 
total_memory_lines = int(total_bytes / 32);

for line in range(0,total_memory_lines):
  f.write(hex(line*32) + ":\t")
  for byte in range(0,32):
     if (byte % 8 == 0):
         f.write("  ")
     f.write(hexArray[(line*32) + byte] + " ")
  f.write("\n")

f.close()

# Create memory load files
total_memory_lines = int(total_bytes / total_width);
number_of_memories_wide = int(total_width / memory_width);
number_of_memories_deep = int(total_memory_lines / memory_depth);

for memory_x in range(0,number_of_memories_wide):
  for memory_y in range(0,number_of_memories_deep):
    file_name = "./test_generation/" + memory_name + "_" + str(memory_y) + "_" + str(memory_x)
    f = open(file_name, "w")
    for line in range(0,memory_depth):
        x_offset = memory_x * memory_width
        y_offset = memory_y * memory_depth

        for byte in range(0,memory_width):
           f.write(hexArray[(y_offset+line) * total_width + (byte + x_offset)] + " ")

        f.write("\n")
    f.close()
 
