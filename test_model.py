import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

print("🔄 Model load ho raha hai... Thoda intezar karein (8GB RAM optimization active)...")

# Local directory se model aur tokenizer uthana
model_path = "./model"
tokenizer = AutoTokenizer.from_pretrained(model_path)
model = AutoModelForCausalLM.from_pretrained(
    model_path, 
    torch_dtype=torch.float16, # Memory bachane ke liye float16 use kiya hai
    device_map="auto"
)

print("✅ Model load ho gaya! Ab test prompt bhej rahe hain...")

prompt = "Hello! Tell me in one short sentence: What is MLOps?"
messages = [{"role": "user", "content": prompt}]
text = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)

model_inputs = tokenizer([text], return_tensors="pt").to(model.device)
generated_ids = model.generate(**model_inputs, max_new_tokens=50)

response = tokenizer.batch_decode(generated_ids, skip_special_tokens=True)[0]
print("\n🤖 AI Response:")
print(response.split("assistant\n")[-1])