import json

def user_to_prompt(user):
    return (
        f"My age is {user['age']}, my monthly income is {user['monthly_income']}, "
        f"and I’m {user['employment_type'].lower()}. What loans am I eligible for?"
    )

def output_to_response(output):
    if output["recommended_loans"]:
        loans = ", ".join(output["recommended_loans"])
        return f"You are eligible for the following loans: {loans}."
    else:
        return "You are not eligible for any available loan products."

# Read original dataset
with open("loan_recommendation_accounts_salary.jsonl", "r") as fin:
    lines = [json.loads(line) for line in fin]

# Convert to Mistral format
mistral_dataset = []
for entry in lines:
    prompt = user_to_prompt(entry["input"])
    response = output_to_response(entry["output"])
    mistral_dataset.append({
        "messages": [
            { "role": "user", "content": prompt },
            { "role": "assistant", "content": response }
        ]
    })

# Save to JSONL file
with open("mistral_loan_finetune.jsonl", "w") as fout:
    for entry in mistral_dataset:
        fout.write(json.dumps(entry) + "\n")

print("✅ Conversion completed. Ready for Mistral fine-tuning.")
