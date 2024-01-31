
import torch
import numpy
import sys

sys.stdout.write("3\n")
f = open("/Users/andyyu/Desktop/Coding/Processing/processing-mnist/processing_mnist/file.txt", "a")
f.write("\"Testing 1 2 3\"")
f.close()

sys.stdout.flush()
sys.stdout.close()
sys.exit(0)
