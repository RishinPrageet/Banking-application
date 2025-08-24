from datetime import datetime
import time
import logging
import subprocess
import requests
import numpy as np
import faiss

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr
from typing import List, Dict, Any, Optional
from langchain_community.embeddings import HuggingFaceEmbeddings
from bs4 import BeautifulSoup

import os
from mistralai import Mistral

api_key = "yg1pHQFYZlCMsBmJzpS70QbsYNNlFuW1"

client = Mistral(api_key=api_key)

# ─── Logging Setup ──────────────────────────────────────────────────────────────
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s %(levelname)s %(name)s: %(message)s')
logger = logging.getLogger(__name__)

# ─── FastAPI App ──────────────────────────────────────────────────────────────
app = FastAPI(title="Loan RAG Chatbot API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ─── HTML Cleaner ──────────────────────────────────────────────────────────────

def clean_ollama_response(text: str) -> str:
    soup = BeautifulSoup(text, "html.parser")
    for think_tag in soup.find_all("think"):
        think_tag.decompose()
    return soup.get_text(strip=True)

# ─── Ollama HTTP Config ────────────────────────────────────────────────────────
OLLAMA_URL = "https://api.mistral.ai/v1/agents/completions"

def ensure_ollama_running() -> bool:
    return True

def query_ollama(prompt: str, system_prompt: Optional[str] = None) -> str:
    chat_response = client.agents.complete(
        agent_id="ag:98c5249c:20250528:refactored-bank-chatbot:c4c1cf34",
        messages=[
            {
                "role": "user",
                "content": "" + prompt,
            },
        ],
    )
    return chat_response.choices[0].message.content

# ─── Loan Knowledge Base & FAISS Setup ───────────────────────────────────────────
LOAN_DATA = [
    {"id":1, "loan_type":"Home Loan", "interest_rate":7.5,  "max_amount":5_000_000, "duration_months":240,
     "eligibility_criteria":"Minimum income 50,000/month, Age 21-60, Salaried or Self-employed"},
    {"id":2, "loan_type":"Personal Loan", "interest_rate":12.0, "max_amount":1_000_000, "duration_months":60,
     "eligibility_criteria":"Minimum income 25,000/month, Age 21-58, Salaried"},
    {"id":3, "loan_type":"Car Loan", "interest_rate":9.0,    "max_amount":2_000_000, "duration_months":84,
     "eligibility_criteria":"Minimum income 20,000/month, Age 21-60, Salaried or Self-employed"},
    {"id":4, "loan_type":"Education Loan", "interest_rate":10.5, "max_amount":1_500_000, "duration_months":96,
     "eligibility_criteria":"Student, Admission in recognized institution, Co-applicant required"},
    {"id":5, "loan_type":"Gold Loan", "interest_rate":11.0,   "max_amount":500_000,     "duration_months":36,
     "eligibility_criteria":"Gold collateral required, Age 18-65"},
    {"id":6, "loan_type":"Business Loan", "interest_rate":13.0,"max_amount":3_000_000, "duration_months":84,
     "eligibility_criteria":"Business vintage 3+ years, Minimum turnover 10L/year"},
    {"id":7, "loan_type":"Two Wheeler Loan", "interest_rate":10.0,"max_amount":200_000, "duration_months":48,
     "eligibility_criteria":"Minimum income 10,000/month, Age 18-60"},
    {"id":8, "loan_type":"Loan Against Property", "interest_rate":8.5,"max_amount":4_000_000, "duration_months":180,
     "eligibility_criteria":"Property ownership, Age 25-65, Income proof"},
    {"id":9, "loan_type":"Agriculture Loan", "interest_rate":7.0, "max_amount":1_000_000, "duration_months":60,
     "eligibility_criteria":"Farmer, Land documents required"},
    {"id":10,"loan_type":"Travel Loan", "interest_rate":14.0,  "max_amount":500_000,     "duration_months":36,
     "eligibility_criteria":"Minimum income 20,000/month, Age 21-55"}
]

documents = [
    f"Loan Type: {loan['loan_type']}\n"
    f"Interest Rate: {loan['interest_rate']}%\n"
    f"Maximum Amount: ₹{loan['max_amount']}\n"
    f"Duration: {loan['duration_months']} months\n"
    f"Eligibility: {loan['eligibility_criteria']}"
    for loan in LOAN_DATA
]

logger.info("Initializing embeddings...")
emb_model = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")
doc_embs = np.array(emb_model.embed_documents(documents), dtype="float32")
index = faiss.IndexFlatL2(doc_embs.shape[1])
index.add(doc_embs)
logger.info("FAISS index ready with %d vectors.", index.ntotal)

# ─── Request/Response Models ───────────────────────────────────────────────────
class User(BaseModel):
    id: int
    username: str
    password: str
    role: str
    email: EmailStr
    createdAt: datetime
    accountIds: List[int]
    admin: bool
    name: str

class Account(BaseModel):
    id: int
    amount: int
    accountType: str
    creationDate: Optional[datetime] = None
    interestRate: float

class UserResponse(BaseModel):
    session_id: str
    user_details: User
    account_details: List[Account]

# ─── In-Memory Store ───────────────────────────────────────────────────────────
USER_DATA: Dict[str, Dict[str, Any]] = {}

def update_user_data(session_id: str, user: Dict[str, Any], accounts: List[Dict[str, Any]]) -> None:
    USER_DATA[session_id] = {"user": user, "accounts": accounts}
    logger.info("Updated USER_DATA for session %s", session_id)

# ─── Chat Endpoint ─────────────────────────────────────────────────────────────
@app.post("/chat", response_model=Dict[str, Any])
async def chat(request: Dict[str, Any]):
    if not ensure_ollama_running():
        return {"response": "Ollama not available.", "sources": []}

    session_store = USER_DATA.get(request.get("session_id"), {})
    user_dict = session_store.get("user", {})
    acct_list = session_store.get("accounts", [])

    parts = []
    if user_dict:
        parts.append("User Profile:\n" + "\n".join(                   
            f"{k}: {v}" for k, v in user_dict.items() if k not in ("password")
        ))
    if acct_list:
        acct_lines = []
        for acct in acct_list:
            acct_lines.append(
                f"- Account {acct['id']} ({acct['accountType']}): ₹{acct['amount']}, "
                f"Rate {acct['interestRate']}%, opened {acct.get('creationDate') or 'N/A'}"
            )
        parts.append("Accounts context:\n" + "\n".join(acct_lines))

    user_context = "\n\n".join(parts)

    q_emb = np.array(emb_model.embed_query(request.get("message")), dtype="float32")[None, :]
    D, I = index.search(q_emb, 3)
    retrieved_texts = [documents[i] for i in I[0]]
    retrieved_meta  = [LOAN_DATA[i] for i in I[0]]

    system_prompt = (
        "You are a helpful banking assistant. Use ONLY the information provided in the 'User Details', "
        "'Accounts', and 'Loan Context' sections. "
        "If asked about the user's personal info (name, username, email, etc.), answer straight from 'User Details'. "
        "If you don't know, say 'I don't know.' "
        "If asked about Accounts or any thing similar to accounts (bank statements etc)  answer directly from 'Accounts' context. "
        "Loan Context is retrieved from a knowledge base. use loan context to answer about loans "
        "Cite loan types when relevant. Keep all answers under 4 sentences."
    )
    prompt = (
        f"{user_context}\n\nLoan Context:\n" + "\n\n".join(retrieved_texts) +
        f"\n\nUser Question: {request.get('message')}\nAnswer:"
    )
    print(prompt)

    raw = query_ollama(prompt, system_prompt)
    answer = clean_ollama_response(raw)

    print(raw)

    sources = [
        {"loan_type": meta["loan_type"],
         "interest_rate": meta["interest_rate"],
         "relevance": float(1.0 / (1.0 + dist))}
        for dist, meta in zip(D[0], retrieved_meta) 
    ]

    return {"response": answer, "sources": sources}

# ─── Update User Endpoint ──────────────────────────────────────────────────────
@app.post("/update_user")
async def update_user(req: UserResponse):
    update_user_data(
        req.session_id,
        req.user_details.dict(),
        [acct.dict() for acct in req.account_details]
    )
    return {"status": "success", "message": "User details updated."}

# ─── Health Check & Run ────────────────────────────────────────────────────────
@app.get("/health")
async def health():
    return {"status": "ok", "ollama": ensure_ollama_running()}

if __name__ == "__main__":
    import uvicorn
    logger.info("Starting Loan RAG Chatbot API on port 8000")
    uvicorn.run(app, host="0.0.0.0", port=8000)
