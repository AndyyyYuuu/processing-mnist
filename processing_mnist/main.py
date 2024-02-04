import numpy
import torch
import torch.nn.functional as F
import torchvision
import sys
import os
from model import Net
from PIL import Image

directory = os.path.dirname(os.path.abspath(__file__))

img_transform = torchvision.transforms.Compose(
    [torchvision.transforms.Grayscale(num_output_channels=1), torchvision.transforms.ToTensor(), torchvision.transforms.Normalize((0.1307,), (0.3081,))]
)

image = Image.open(os.path.join(directory, "drop.png"))
input_tensor = img_transform(image).unsqueeze(0)

nn = Net()
nn.load_state_dict(torch.load(os.path.join(directory, "models/model_1.pth")))

with torch.no_grad():
    output = torch.argmax(nn(input_tensor))
sys.stdout.write(str(output.item()))
sys.stdout.flush()
sys.stdout.close()
sys.exit(0)
