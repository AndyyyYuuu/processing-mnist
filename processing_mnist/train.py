import numpy
import torch
import torchvision
import torch.nn.functional as F
from tqdm import tqdm
import sys
from model import Net

NUM_EPOCHS = 3
BATCH_SIZE = 64
TEST_BATCH_SIZE = 1000
LEARNING_RATE = 0.01
MOMENTUM = 0.5
LOG_INTERVAL = 10

torch.backends.cudnn.enabled = False
torch.manual_seed(1)

train_loader = torch.utils.data.DataLoader(
    torchvision.datasets.MNIST('datasets/', train=True, download=True,
                               transform=torchvision.transforms.Compose([
                                   torchvision.transforms.ToTensor(),
                                   torchvision.transforms.Normalize(
                                       (0.1307,), (0.3081,))
                               ])),
    batch_size=BATCH_SIZE, shuffle=True)

test_loader = torch.utils.data.DataLoader(
    torchvision.datasets.MNIST('datasets/', train=False, download=True,
                               transform=torchvision.transforms.Compose([
                                   torchvision.transforms.ToTensor(),
                                   torchvision.transforms.Normalize(
                                       (0.1307,), (0.3081,))
                               ])),
    batch_size=TEST_BATCH_SIZE, shuffle=True)

nn = Net()
optimizer = torch.optim.SGD(nn.parameters(), lr=LEARNING_RATE, momentum=MOMENTUM)

def train(epoch):
    nn.train()
    for batch_idx, (data, target) in enumerate(tqdm(train_loader)):
        optimizer.zero_grad()
        output = nn(data)
        loss = F.nll_loss(output, target)
        loss.backward()
        optimizer.step()
        if batch_idx % LOG_INTERVAL == 0:
            torch.save(nn.state_dict(), 'models/model_1.pth')
            torch.save(optimizer.state_dict(), 'models/optimizer_1.pth')
    print(f"--Epoch {epoch}-- \n  Loss: {loss.item()}")


def test():
    nn.eval()
    test_loss = 0
    correct = 0
    with torch.no_grad():
        for data, target in test_loader:
            output = nn(data)
            test_loss += F.nll_loss(output, target, size_average=False).item()
            pred = output.data.max(1, keepdim=True)[1]
            correct += pred.eq(target.data.view_as(pred)).sum()
    test_loss /= len(test_loader.dataset)
    print('\nTest set: Avg. loss: {:.4f}, Accuracy: {}/{} ({:.0f}%)\n'.format(
        test_loss, correct, len(test_loader.dataset),
        100. * correct / len(test_loader.dataset)))


for epoch in range(1, NUM_EPOCHS + 1):
    train(epoch)
    test()