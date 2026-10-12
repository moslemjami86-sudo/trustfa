import os

_BASE = os.path.dirname(os.path.abspath(__file__))
_DEFAULT_SQLITE = "sqlite:///" + os.path.join(_BASE, "trustfa.db").replace("\\", "/")

# PostgreSQL example:
# DATABASE_URL=postgresql+psycopg2://trustfa:trustfa@localhost:5432/trustfa
DATABASE_URL = os.getenv("DATABASE_URL", _DEFAULT_SQLITE)

SECRET_KEY = os.getenv("SECRET_KEY", "trustfa-change-me-in-production-2026")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_DAYS = 30
UPLOAD_DIR = os.getenv("UPLOAD_DIR", os.path.join(_BASE, "..", "uploads"))
CORS_ORIGINS = [o.strip() for o in os.getenv("CORS_ORIGINS", "*").split(",") if o.strip()]

# Google OAuth (از Google Cloud Console → Credentials → OAuth 2.0 Client ID نوع Web)
GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID", "")

# ایمیل‌هایی که خودکار ادمین می‌شوند (با کاما جدا)
ADMIN_EMAILS = [
    e.strip().lower()
    for e in os.getenv("ADMIN_EMAILS", "admin@trustfa.ir").split(",")
    if e.strip()
]
