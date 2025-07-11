import torch
import torch.nn as nn

class SimpleModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.linear = nn.Linear(10, 5)
        self.relu = nn.ReLU()
        
    def forward(self, x):
        return self.relu(self.linear(x))

# 创建模型和示例输入
model = SimpleModel()
example_input = torch.randn(1, 10)

# 导出为ONNX（可选步骤）
torch.onnx.export(model, example_input, "model.onnx")