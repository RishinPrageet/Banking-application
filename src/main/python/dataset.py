import json
import random
from faker import Faker

fake = Faker()

loan_types = [
    "personal loan", "home loan", "two-wheeler loan", "car loan", "gold loan",
    "education loan", "business loan", "agriculture loan", "travel loan", "medical loan"
]

account_questions = [
    "Can you tell me my current account balance?",
    "What type of account do I have?",
    "Is my loan account active?",
    "Do I have any outstanding loans?",
    "Show me the last five transactions.",
    "When is my EMI due?",
    "What is the interest rate on my savings account?",
    "Can I convert my savings account to a fixed deposit?",
    "How much loan can I take based on my salary?",
    "Can I increase my credit limit?"
]

def generate_entry(loan_type=None, income_assets=False, account_query=False):
    if account_query:
        user_input = random.choice(account_questions)
        response = f"Sure, here’s the information: {fake.sentence()}."
    elif income_assets:
        income = random.randint(10000, 100000)
        assets = random.choice(["a car", "a house", "gold worth ₹2 lakhs", "two properties"])
        user_input = f"My monthly income is ₹{income} and I own {assets}. Am I eligible for a {loan_type}?"
        response = f"Based on your income and assets, you may be eligible for a {loan_type}. Please submit your documents for verification."
    else:
        user_input = f"Can you give me details about a {loan_type}?"
        response = f"Sure, a {loan_type} offers flexible terms and interest rates depending on your profile. Would you like to apply?"

    return {
        "messages": [
            {"role": "user", "content": user_input},
            {"role": "assistant", "content": response}
        ]
    }

entries = []

# 100 entries about different loan types
for _ in range(100):
    entries.append(generate_entry(loan_type=random.choice(loan_types)))

# 125 entries with income and assets
for _ in range(125):
    entries.append(generate_entry(loan_type=random.choice(loan_types), income_assets=True))

# 125 entries related to bank account questions
for _ in range(125):
    entries.append(generate_entry(account_query=True))

# Save as JSONL
path = "loan_chatbot_finetune_dataset_350.jsonl"
with open(path, "w") as f:
    for entry in entries:
        f.write(json.dumps(entry) + "\n")

path
